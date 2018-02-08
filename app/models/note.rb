class Note < ApplicationRecord
  has_many :note_tags, dependent: :delete_all
  has_many :tags, -> { uniq }, through: :note_tags

  has_one :primary_note_tag, -> { where primary: true }, class_name: "NoteTag"
  has_one :primary_tag, through: :primary_note_tag, source: :tag
end
