class AddSeentodayToNotes < ActiveRecord::Migration[5.0]
  def change
    add_column :notes, :seentoday, :boolean
  end
end
