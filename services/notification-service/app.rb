require 'sinatra'
require 'json'

set :bind, '0.0.0.0'
set :port, 4567

get '/health' do
  content_type :json
  { status: 'UP', service: 'notification-service' }.to_json
end

post '/notify' do
  content_type :json
  begin
    data = JSON.parse(request.body.read)
    # Simulate sending notification
    puts "Sending notification to #{data['user_id']}: #{data['message']}"
    status 200
    { status: 'sent', recipient: data['user_id'] }.to_json
  rescue JSON::ParserError
    status 400
    { error: 'Invalid JSON' }.to_json
  end
end
