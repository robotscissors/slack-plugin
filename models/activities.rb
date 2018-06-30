class Activities < ActiveRecord::Base

  def self.start(slack_user)
    #create the new user log
    @new_entry = User.create(slack_identifier: slack_user[:user_id], slack_command: slack_user[:command])
    return true if @new_entry.save #let's save the new Record return true if no errors
    false 
  end

  def self.stopclock
  end

end
