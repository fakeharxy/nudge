class AddLastCleanupToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_cleanup, :date
  end
end
