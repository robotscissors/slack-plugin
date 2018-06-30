require 'sinatra'
require 'sinatra/activerecord'
require 'time_difference'

require './models/user'
require './models/activities'
require 'pry-byebug'


get '/' do
  'Hello there, slack user!!'
end

ERROR = ':boom: Error. I am sure it isn\' anything serious, but I am not sure what command you were trying. Additional commands you can use are: start, stop or restart just leave it blank for stats.'

post '/slack/command' do
  @slack_user = params #get the slack ID unique identifier
  @user = User.find_by(slack_identifier: @slack_user[:user_id]) #does the user exist?
  ## find out what the user wants to do
  case params[:text].to_s.strip.downcase
  when '' #user just wants any stats and the current state
    if @user
      message = Activities.get_time_log(@slack_user)
      content_type :json
      {
        :response_type => "ephemeral",
        :text => ":clock2: CURRENT LOG",
        :attachments =>[
           {
              :text => "#{message}",
              :color => "#36a64f"
           }
       ]
     }.to_json
    else
      "There is no log to report"
    end
  when 'start' #user wants to mark thst start of the clock
    message = Activities.start(@slack_user)
    content_type :json
    {
      :response_type => "ephemeral",
      :attachments =>[
        {
          :text => "#{message}",
          :color => "#36a64f"
        }
      ]
    }.to_json
  when 'stop' #stop the clock we are done
    if @user #check to make sure the timer has started
      message = Activities.stop(@slack_user)
      content_type :json
      {
        :response_type => "ephemeral",
        :attachments =>[
          {
            :text => "#{message}",
            :color => "#990000"
          }
        ]
      }.to_json
    else #oops they need to start the timer before they can stop it -help user
      content_type :json
      {
        :response_type => "ephemeral",
        :attachments =>[
          {
            :text => "You need to start the timer first using ```/SlackTrack start```",
            :color => "#990000"
          }
        ]
      }.to_json
    end
  when 'restart' #give stats to the user
    message = Activities.restart(@slack_user)
    content_type :json
    {
      :response_type => "ephemeral",
      :attachments =>[
        {
          :text => "#{message}",
          :color => "#990000"
        }
      ]
    }.to_json
  when 'clear' #wipe out entire user
    message = Activities.clear(@slack_user)
    content_type :json
    {
      :response_type => "ephemeral",
      :attachments =>[
        {
          :text => "#{message}",
          :color => "#990000"
        }
      ]
    }.to_json
  when 'help' #give stats to the user
    "Will give you the help"
  else
    content_type :json
    {:text => "#{ERROR}"}.to_json
  end
end
