class AddLastseenToNotes < ActiveRecord::Migration[5.0]
  def change
    add_column :notes, :lastseen, :date
  end
end
