class Note < ApplicationRecord
  has_many :note_tags, dependent: :delete_all
  has_many :tags, -> { distinct }, through: :note_tags

  has_one :primary_note_tag, -> { where primary: true }, class_name: 'NoteTag'
  has_one :primary_tag, through: :primary_note_tag, source: :tag
  after_initialize :init

  def init
    self.last_seen ||= Date.today
    self.seentoday ||= false
  end

  def destroy_with_tags
    oldtag_ids = tag_ids
    destroy
    Tag.find(oldtag_ids).each do |tag|
      tag.destroy if tag.notes == []
    end
  end

  def add_primary_tag=(tag)
    if Tag.exists?(name: tag)
      self.primary_tag = Tag.find_by(name: tag)
    else
      self.primary_tag = Tag.create!(name: tag, importance: 5)
    end
  end

  def get_primary_tag_name
    self.primary_tag.name
  end

  def add_secondary_tags=(secondary_tags)
    self.tags = secondary_tags.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  def get_all_tag_names
    Tag.all.map(&:name)
  end
end
