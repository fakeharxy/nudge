class Note < ApplicationRecord
  has_many :note_tags, dependent: :delete_all
  has_many :tags, -> { distinct }, through: :note_tags

  has_one :primary_note_tag, -> { where primary: true }, class_name: 'NoteTag'
  has_one :primary_tag, through: :primary_note_tag, source: :tag
  after_initialize :init
  attr_accessor :secondary_tags

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
      self.update(primary_tag: Tag.find_by(name: tag))
      self.primary_tag.set_importance = 5 if self.primary_tag.importance == nil
      self.save
    else
      self.primary_tag = Tag.create!(name: tag, importance: 5)
      self.save
    end
  end

  def get_primary_tag_name
    self.primary_tag.name
  end

  def set_last_seen=(date)
    self.last_seen = date
    self.save
  end

  def add_secondary_tags=(secondary_tags)
    self.tags = secondary_tags.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
    self.save
  end

  def get_all_tag_names
    Tag.all.map(&:name)
  end

  def urgency
    self.primary_tag.importance * time_since_last_seen
  end

  def self.get_most_urgent
    Note.all.sort_by{|i| - i.urgency}.first
  end

  def time_since_last_seen
    ((Date.today - self.last_seen) + 1).to_i
  end
end
