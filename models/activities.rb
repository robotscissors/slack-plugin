class Activities < ActiveRecord::Base

  def self.start(slack_user)
    #create the new user log
    activity = "start"
    self.update(slack_user, activity)
  end

  def self.stop(slack_user)
    #create the new user log
    activity = "stop"
    self.update(slack_user, activity)
  end

  def self.restart(slack_user)
    #lets make sure the clock needs to be reset
    @last = User.find_by(slack_identifier: slack_user[:user_id])
    if @last.slack_activity === "start"
      activity = "start"
      return self.update(slack_user, activity) #reset clock
    end
    false
  end

  private

  def self.update(slack_user, activity)
    @new_entry = User.create(slack_identifier: slack_user[:user_id], slack_command: slack_user[:command], slack_activity: activity)
    return true if @new_entry.save #let's save the new Record return true if no errors
    false
  end

end
