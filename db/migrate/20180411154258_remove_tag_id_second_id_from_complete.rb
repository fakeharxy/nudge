class RemoveTagIdSecondIdFromComplete < ActiveRecord::Migration[5.0]
  def change
    remove_column :completes, :tag_id, :string
    remove_column :completes, :second_id, :string
  end
end
