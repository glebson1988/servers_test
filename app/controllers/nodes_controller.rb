class NodesController < ApplicationController

  post '/nodes' do
    return { error: 'IP address is missing.' }.to_json if params[:ip_address].blank?

    node = Node.new(ip_address: params[:ip_address])

    if node.save
      { message: "New node with IP-address #{node.ip_address} was added to statistics" }.to_json
    else
      { error: "#{node.errors.full_messages.join('')}" }.to_json
    end
  end

  get '/nodes' do
    return { message: 'Node list is empty' }.to_json if Node.count.zero?

    { list: Node.all }.to_json
  end

  delete '/nodes' do
    return ip_not_found unless node

    node.destroy

    { message: 'IP was successfully deleted' }.to_json
  end

  get '/statistics' do
    return ip_not_found unless node

    if node.statistics.empty?
      { error: "#{node.ip_address} doesn't have statistics" }.to_json
    else
      data = Statistic.where(node: node)
                      .where("start_time >= ? AND end_time <= ?", params[:start_time], params[:end_time])

      # TODO: return json with data
    end
  end

  get '/start_ping' do
    return ip_not_found unless node

    start_ping(node)
  end

  post '/stop_ping' do
    return ip_not_found unless node

    stop_ping
  end

  private

  def node
    @node ||= Node.find_by_ip_address(params[:ip_address])
  end

  def ip_not_found
    { error: 'This IP is not in the database' }.to_json
  end

  def start_ping(node); end

  def stop_ping; end
end
