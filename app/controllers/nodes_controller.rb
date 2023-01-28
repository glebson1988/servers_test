class NodesController < ApplicationController

  post '/nodes' do
    return { error: 'IP address missing or invalid format. Valid format: 8.8.8.8' }.to_json if params[:ip_address].blank?

    node = Node.new(ip_address: params[:ip_address])

    if node.save
      { message: "New node with IP-address #{node.ip_address} was added to statistics" }.to_json
    else
      { error: 'IP address already exists' }.to_json
    end
  end

  get '/nodes' do
    return { message: 'Node list is empty' }.to_json if Node.count.zero?

    { list: Node.all }.to_json
  end

  delete '/nodes' do
    node = Node.find_by_ip_address(params[:ip_address])

    return { error: 'This IP is not in the database' }.to_json unless node

    node.destroy
    { message: 'IP was successfully deleted' }.to_json
  end
end
