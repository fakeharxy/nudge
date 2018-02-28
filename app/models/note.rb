class Note < ApplicationRecord
  has_many :note_tags, dependent: :delete_all
  has_many :tags, -> { distinct }, through: :note_tags

  has_one :primary_note_tag, -> { where primary: true }, class_name: 'NoteTag'
  has_one :primary_tag, through: :primary_note_tag, source: :tag

  belongs_to :user, optional: true
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

  def add_primary_tag(tag, user_id)
    if Tag.exists?(name: tag)
      self.update(primary_tag: Tag.find_by(name: tag))
      self.primary_tag.set_importance = 3 if self.primary_tag.importance == nil
      self.save
    else
      self.primary_tag = Tag.create!(name: tag, importance: 3, user_id: user_id)
      self.save
    end
  end

  def get_primary_tag_name
    self.primary_tag.name
  end

  def seen_today?
    self.seentoday
  end

  def set_last_seen=(date)
    self.last_seen = date
    self.save
  end

  def add_secondary_tags(secondary_tags, user_id)
    self.tags << secondary_tags.split(",").map do |n|
      Tag.where(name: n.strip, user_id: user_id).first_or_create!
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
    Note.where("seentoday = false").sort_by{|i| - i.urgency}.first
  end

  def mark_as_seen
    self.set_last_seen = Date.today
    self.update(seentoday: true)
  end

  def self.all_seen?(user_id)
    !Note.exists?(user_id: user_id, seentoday: false)
  end

  def self.most_recent(user_id)
    Note.where('user_id = ?', user_id).order('last_seen DESC').first
  end


  def self.reset_seen_status(user_id)
    Note.where('user_id = ?', user_id).update_all(seentoday: false)
  end

  def time_since_last_seen
    ((Date.today - self.last_seen) + 1).to_i
  end
end
