class NoteTag < ApplicationRecord
  belongs_to :note
  belongs_to :tag, dependent: :destroy
end
