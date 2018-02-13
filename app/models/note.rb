class Note < ApplicationRecord
  has_many :note_tags, dependent: :delete_all
  has_many :tags, -> { uniq }, through: :note_tags

  has_one :primary_note_tag, -> { where primary: true }, class_name: 'NoteTag'
  has_one :primary_tag, through: :primary_note_tag, source: :tag

  def destroy_with_tags
    oldtag_ids = tag_ids
    destroy
    Tag.find(oldtag_ids).each do |tag|
      tag.destroy if tag.notes == []
    end 
  end
end
