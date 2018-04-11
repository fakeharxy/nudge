class RemoveTagIdSecondIdFromComplete < ActiveRecord::Migration[5.0]
  def change
    remove_column :completes, :tag_id, :integer
    remove_column :completes, :second_id, :integer
  end
end
