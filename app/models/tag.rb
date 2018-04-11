class Tag < ApplicationRecord
  has_many :notes
  has_many :completes
  has_many :seconds
  belongs_to :user, optional: true

  def set_importance=(importance)
    self.update(importance: importance)
  end

  def cleanup
    destroy if note_count == 0
  end

  def note_count
    self.notes.uniq.count
  end

  def self.in_order_of_most_used(user_id)
    Tag.where(user_id: user_id).sort_by{|i| - i.note_count}
  end

  def self.get_all_tags(user_id)
    Tag.where(user_id: user_id).where.not('importance' => nil)
  end

  def get_all_seconds
    self.seconds
  end

  def get_all_notes
    self.notes.uniq
  end
end
