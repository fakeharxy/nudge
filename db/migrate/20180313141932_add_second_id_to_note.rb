class AddSecondIdToNote < ActiveRecord::Migration[5.0]
  def change
    add_reference :notes, :second, index: true 
  end
end
