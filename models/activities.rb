# This class contains all the activites associated with a slack user
# it calculates start and stop time differences, produces the log
# and inserts items into the user database.

class Activities < ActiveRecord::Base

  def self.start(slack_user)
    #check is this a new user?
    @user = User.where(slack_identifier: slack_user[:user_id])
    #check to see what the last command was if it was start we should let the user know
    if @user.empty?
      activity = "start"
      return "Time starts now! Go get'em." if self.update(slack_user, activity)
    end
    #check to see if the last activity is start
    @last_activity = @user.last.slack_activity
    return "You already started the clock." if @last_activity === 'start'
    activity = "start" #otherwise go ahead and get started
    return "Time starts now! Go get'em." if self.update(slack_user, activity)
  end

  def self.stop(slack_user)
    #check to see what the last command was if it was stop we should let the user know
    @last_activity = User.where(slack_identifier: slack_user[:user_id]).last.slack_activity
    return "You already stopped the clock" if @last_activity === 'stop'
    #create the new user log
    activity = "stop"
    if self.update(slack_user, activity)
      "The clock has been stopped. \n#{self.get_time_log(slack_user)}"
    else
      "There was an error, please try again."
    end
  end

  def self.restart(slack_user)
    #lets make sure the clock needs to be reset
    @last = User.where(slack_identifier: slack_user[:user_id]).last
    if @last.slack_activity === "start"
      activity = "start"
      if self.update(slack_user, activity) #reset clock
        "The clock has been reset! Get busy!"
      end
    end
    "It looks like the clock hasn't started yet. \nUse ```/SlackTrack start``` command."
  end

  def self.get_time_log(slack_user)
    #get the last start command that was issued - that is the start_time
    @last_start_time = User.where(slack_identifier: slack_user[:user_id], slack_activity: "start").last
    return false unless @last_start_time
    #what was the last command that was executed?
    @last_stop_time = User.where(slack_identifier: slack_user[:user_id], slack_activity: "stop").last
    #if there is no stop yet, or the stop time was before the start time
    return "You're still on the clock! \nSo far you spent: \n#{get_time_duration(@last_start_time.created_at,Time.now)}" if !@last_stop_time || (@last_stop_time.created_at < @last_start_time.created_at)
    #otherwise there was a full session and you should report it
    "Your total slack time for the last session was: \n#{get_time_duration(@last_start_time.created_at,@last_stop_time.created_at)}"
  end

  def self.clear(slack_user)
      return "There was an error in clearing the data" if !self.delete(slack_user[:user_id])
      "All timelogs were deleted for this user"
  end

  def self.get_time_duration(start_time, end_time)
    TimeDifference.between(start_time, end_time).humanize
  end

  private

  def self.update(slack_user, activity)
    @new_entry = User.create(slack_identifier: slack_user[:user_id], slack_command: slack_user[:command], slack_activity: activity)
    return true if @new_entry.save #let's save the new Record return true if no errors
    false
  end

  def self.delete(slack_user)
    #completely removes data for user
    User.where(slack_identifier: slack_user).destroy_all
  end
end
