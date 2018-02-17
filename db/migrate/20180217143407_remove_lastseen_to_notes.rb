class RemoveLastseenToNotes < ActiveRecord::Migration[5.0]
  def change
    remove_column :notes, :lastseen, :date
  end
end
