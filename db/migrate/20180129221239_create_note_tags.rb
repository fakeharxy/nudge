class CreateNoteTags < ActiveRecord::Migration[5.0]
  def change
    create_table :note_tags do |t|
      t.belongs_to :note, foreign_key: true
      t.belongs_to :tag, foreign_key: true
      t.boolean :primary

      t.timestamps
    end
  end
end
