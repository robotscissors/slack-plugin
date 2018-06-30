class Activities < ActiveRecord::Base

  def self.start(slack_user)
    #create the new user log
    self.update(slack_user)
  end

  def self.stop(slack_user)
    #create the new user log
    self.update(slack_user)
  end

  private

  def self.update(slack_user)
    @new_entry = User.create(slack_identifier: slack_user[:user_id], slack_command: slack_user[:command], slack_activity: slack_user[:text].downcase)
    return true if @new_entry.save #let's save the new Record return true if no errors
    false
  end

end
