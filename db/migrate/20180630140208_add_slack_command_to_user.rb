class AddSlackCommandToUser < ActiveRecord::Migration[5.2]
  def change
      add_column :users, :slack_command, :string
  end
end
