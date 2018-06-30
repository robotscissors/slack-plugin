require 'sinatra'

get '/' do
  'Hello there slack user!!'
end

ERROR = 'Error. I am sure it isn\' anything serious. I am not sure what command you were trying. Additional commands you can add: start, stop or just leave it blank for stats'

post '/slack/command' do
  case params['text'].to_s.strip.downcase
  when ''
    "nothing there"
  when 'start'
    content_type :json
    {:text => "OK, Let's start the clock"}.to_json
  when 'stop'
    "TIME! Ok, stopped the clock."
  when 'time'
    "Will give you the time spent."
  else
    ERROR
  end
end
