class Second < ApplicationRecord
  has_many :notes
  belongs_to :tag

  def get_all_notes
    self.notes.uniq
  end
end
