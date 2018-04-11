class Second < ApplicationRecord
  has_many :notes
  has_many :complete
  belongs_to :tag
  belongs_to :user

  def get_all_notes
    self.notes.uniq
  end

  def cleanup
    destroy if note_count == 0
  end

  def note_count
    self.notes.uniq.count
  end
end
