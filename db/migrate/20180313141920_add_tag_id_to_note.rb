class AddTagIdToNote < ActiveRecord::Migration[5.0]
  def change
    add_reference :notes, :tag, index: true
  end
end
