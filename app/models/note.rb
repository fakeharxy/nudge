class Note < ApplicationRecord
  belongs_to :tag
  belongs_to :second

  belongs_to :user, optional: true
  after_initialize :init
  attr_accessor :secondary_tags

  def init
    self.last_seen ||= Date.today
    self.seentoday ||= false
  end

  def destroy_with_tags
    oldtag_ids = tag_id
    destroy
    Tag.find(oldtag_ids) do |tag|
      tag.destroy if tag.notes == []
    end
  end

  def add_tag(tag, user_id)
    if Tag.exists?(name: tag, user_id: user_id)
      self.update(tag_id: Tag.find_by(name: tag).id)
      self.save
    else
      self.tag = Tag.create!(name: tag, importance: 5, user_id: user_id)
      self.save
    end
  end

  def update_tag(tag)
    self.tag.update(name: tag)
  end

  def update_second(tag)
    self.second.update(name: tag)
  end

  def add_second(name, tag_id)
    if Second.exists?(name: name, tag_id: tag_id)
      self.update(second_id: Second.find_by(name: name).id)
      self.save
    else
      self.second = Second.create!(name: name, tag_id: tag_id)
      self.save
    end
  end

  def get_tag_name
    self.tag.name
  end

  def seen_today?
    self.seentoday
  end

  def set_last_seen=(date)
    self.last_seen = date
    self.save
  end

  def get_all_tag_names
    [tag.name, second.name]
  end

  def urgency
    if(time_since_last_seen <= 2)
      self.tag.importance * time_since_last_seen
    else
      self.tag.importance * (time_since_last_seen * (time_since_last_seen - 1))
    end
  end

  def urgency_level
    case
    when self.urgency >= 40
      return "high"
    when self.urgency >= 15
      return "medium"
    else
      return "low"
    end
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
