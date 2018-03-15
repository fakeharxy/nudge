class CreateSeconds < ActiveRecord::Migration[5.0]
  def change
    create_table :seconds do |t|
      t.string :name
      t.integer :importance
      t.references :tag
      t.references :note

      t.timestamps
    end
  end
end
