class AddTagSecondToComplete < ActiveRecord::Migration[5.0]
  def change
    add_column :completes, :tag, :string
    add_column :completes, :second, :string
  end
end
