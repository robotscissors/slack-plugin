class User < ActiveRecord::Base

  attr_accessor :slack_id

  def initialize(slack_id)
    super
    @slack_id = slack_id
  end



  def update
  end

  def total
  end

end
