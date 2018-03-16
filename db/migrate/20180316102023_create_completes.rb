class CreateCompletes < ActiveRecord::Migration[5.0]
  def change
    create_table :completes do |t|
      t.string :body
      t.references :user, foreign_key: true
      t.references :tag, foreign_key: true
      t.references :second, foreign_key: true

      t.timestamps
    end
  end
end
