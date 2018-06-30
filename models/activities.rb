# This class contains all the activites associated with a slack user
# it calculates start and stop time differences, produces the log
# and inserts items into the user database.

class Activities < ActiveRecord::Base

  def self.start(slack_user)
    #check to see what the last command was if it was start we should let the user know
    @last_activity = User.where(slack_identifier: slack_user[:user_id]).last.slack_activity
    return "You already started the clock" if @last_activity === 'start'
    #create the new user log
    activity = "start"
    if self.update(slack_user, activity)
      "Time starts now! Go get'em"
    else
      "There was an error :boom:"
    end
  end

  def self.stop(slack_user)
    #check to see what the last command was if it was stop we should let the user know
    @last_activity = User.where(slack_identifier: slack_user[:user_id]).last.slack_activity
    return "You already stopped the clock" if @last_activity === 'stop'
    #create the new user log
    activity = "stop"
    if self.update(slack_user, activity)
      "The clock has been stopped. #{self.get_time_log(slack_user)}"
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
    "It looks like the clock hasn't started yet. Use /SlackTrack start command"
  end

  def self.get_time_log(slack_user)
    #get the last start command that was issued - that is the start_time
    @last_start_time = User.where(slack_identifier: slack_user[:user_id], slack_activity: "start").last.created_at
    return false unless @last_start_time
    #what was the last command that was executed?
    @last_stop_time = User.where(slack_identifier: slack_user[:user_id], slack_activity: "stop").last.created_at
    #if there is no stop yet, or the stop time was before the start time
    return "You're still on the clock! So far you spent: #{get_time_duration(@last_start_time,Time.now)}" if !@last_stop_time || (@last_stop_time < @last_start_time)
    #otherwise there was a full session and you should report it
    "Your total slack time for the last session was: #{get_time_duration(@last_start_time,@last_stop_time)}"
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

end
