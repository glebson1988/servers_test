class NodesController < ApplicationController

  post '/nodes' do
    return { error: 'IP address is missing.' }.to_json if params[:ip_address].blank?

    node = Node.new(ip_address: params[:ip_address])

    if node.save
      SaveStatisticsService.new(node:node, start_time: Time.now).execute
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

    query = Statistic.where(node: node)
                          .where('start_time >= ? AND end_time <= ?', params[:start_time], params[:end_time])

    return { message: "No statistics for a given period for #{node.ip_address}" }.to_json if query.empty?

    node_stat(query)
  end

  private

  def node
    @node ||= Node.find_by_ip_address(params[:ip_address])
  end

  def ip_not_found
    { error: 'This IP is not in the database' }.to_json
  end

  def node_stat(stat)
      {
        node_ip: node.ip_address,
        average_rtt: stat.average(:average_rtt),
        minimum_rtt: stat.minimum(:minimum_rtt),
        maximum_rtt: stat.maximum(:maximum_rtt),
        median_rtt: stat.average(:median_rtt),
        standard_deviation: stat.average(:standard_deviation),
        percentage_lost: stat.average(:percentage_lost)
      }.to_json
  end

end
