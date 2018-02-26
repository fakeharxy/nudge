class Tag < ApplicationRecord
  has_many :note_tags
  has_many :notes, through: :note_tags

  belongs_to :user, optional: true

  def set_importance=(importance)
    self.update(importance: importance)
  end

  def note_count
    self.notes.uniq.count
  end

  def self.in_order_of_most_used(user_id)
    Tag.where(user_id: user_id).sort_by{|i| - i.note_count}
  end

  def get_all_notes
    self.notes.uniq
  end
end
