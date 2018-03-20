class AddUserIdToSecond < ActiveRecord::Migration[5.0]
  def change
    add_reference :seconds, :user, :integer, foreign_key: true
  end
end
