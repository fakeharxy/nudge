class Second < ApplicationRecord
  has_many :notes
  belongs_to :tag

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
