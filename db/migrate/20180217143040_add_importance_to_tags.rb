class AddImportanceToTags < ActiveRecord::Migration[5.0]
  def change
    add_column :tags, :importance, :int
  end
end
