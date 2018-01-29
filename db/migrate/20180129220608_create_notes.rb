class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.text :body
      t.date :todo_by
      t.date :last_seen

      t.timestamps
    end
  end
end
