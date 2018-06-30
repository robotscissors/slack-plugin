require 'sinatra'
require 'sinatra/activerecord'

require './models/user'
require './models/activities'
require './models/slack'
require 'pry-byebug'

# ActiveRecord::Base.establish_connection(
#   :adapter => 'sqlite3',
#   :database =>  'slack_application.sqlite3.db'
# )

get '/' do
  'Hello there, slack user!!'
end

ERROR = 'Error. I am sure it isn\' anything serious, but I am not sure what command you were trying. Additional commands you can add: start, stop or just leave it blank for stats.'

post '/slack/command' do
  @slack_identifier = params[:user_id]
  #does the user exist?
  @user = User.find_by(slack_identifier: @slack_identifier)
  binding.pry

  case params[:text].to_s.strip.downcase
  when ''
    "nothing there"
    # give the stats for the current user_id
  when 'start'
    #start the clock for the current user_id
    Activities.start(@slack_identifier)
    content_type :json
    {:text => "OK, Let's start the clock"}.to_json
  when 'stop'
    #stop the clock for the current user_id and report back usage
    "TIME! Ok, stopped the clock."
  when 'time'
    "Will give you the time spent."
  else
    ERROR
  end
end
