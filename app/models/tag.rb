class Tag < ApplicationRecord
  has_many :note_tags
  has_many :notes, through: :note_tags

  def set_importance=(importance)
    self.update(importance: importance)
  end
end
