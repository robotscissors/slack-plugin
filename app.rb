require 'sinatra'
require 'sinatra/activerecord'

require './models/user'
require './models/activities'
require './models/slack'
require 'pry-byebug'

get '/' do
  'Hello there, slack user!!'
end

ERROR = 'Error. I am sure it isn\' anything serious, but I am not sure what command you were trying. Additional commands you can add: start, stop or just leave it blank for stats.'

post '/slack/command' do
  @slack_user = params #get the slack ID unique identifier
  @user = User.find_by(slack_identifier: @slack_user[:user_id]) #does the user exist?
  ## find out what the user wants to do
  case params[:text].to_s.strip.downcase
  when '' #user just wants any stats and the current state
    "nothing there"
  when 'start' #user wants to mark thst start of the clock
    if @user #does the user already have clock starting
      if Activities.start(@slack_user)
        content_type :json
        {:text => "OK, Let's start the clock"}.to_json
      else
        "There was an error please try again"
      end
    else #wait the clock is still running - help the user
      "The clock is already ticking!"
    end
  when 'stop' #stop the clock we are done
    if @user #check to make sure the timer has started
      if Activities.stop(@slack_user)
        "TIME! Ok, stopped the clock."
      else
        "There is a problem, please try again."
      end
    else #oops they need to start the timer before they can stop it -help user
      "You need to start the timer first"
    end
  when 'restart' #give stats to the user
    if Activities.restart(@slack_user)
      "The clock has been reset"
    else
      "Either there was a problem or you haven't started a session yet."
    end
  when 'time' #give stats to the user
    "Will give you the time spent."
  else
    ERROR
  end
end
