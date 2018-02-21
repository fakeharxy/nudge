class Tag < ApplicationRecord
  has_many :note_tags
  has_many :notes, through: :note_tags

  def set_importance=(importance)
    self.update(importance: importance)
  end

  def note_count
    self.notes.count
  end

  def get_all_notes
    self.notes
  end
end
