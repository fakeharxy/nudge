class AddImportanceToNotes < ActiveRecord::Migration[5.0]
  def change
    add_column :notes, :importance, :int
    Note.all.update(importance: 5)
  end
end
