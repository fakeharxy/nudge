class Tag < ApplicationRecord
  has_many :note_tags
  has_many :notes, through: :note_tags

  belongs_to :user

  def set_importance=(importance)
    self.update(importance: importance)
  end

  def note_count
    self.notes.count
  end

  def self.in_order_of_most_used
    Tag.all.sort_by{|i| - i.note_count}
  end

  def get_all_notes
    self.notes
  end
end
