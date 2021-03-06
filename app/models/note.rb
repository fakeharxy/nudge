class Note < ApplicationRecord
  belongs_to :tag
  belongs_to :second

  belongs_to :user, optional: true
  after_initialize :init

  def init
    self.last_seen ||= Date.today
    self.importance ||= 5
    self.seentoday ||= false
  end

  def destroy_with_tags
    oldtag_id = tag_id
    oldsecond_id = second_id
    destroy
    Tag.find_by(id: oldtag_id).destroy if Tag.find_by(id: oldtag_id).notes == []
    Second.find_by(id: oldsecond_id).destroy if Second.find_by(id: oldsecond_id).notes == []
  end

  def transfer_to_complete
    Complete.create!(id: self.id, body: self.body, user_id: self.user_id, tag: Tag.find_by(id: self.tag_id).name, second: Second.find_by(id: self.second_id).name)
    self.destroy_with_tags
  end

  def add_tag(tag, user_id)
    if Tag.exists?(name: tag, user_id: user_id)
      self.update(tag_id: Tag.find_by(name: tag, user_id: user_id).id)
      self.save
    else
      self.tag = Tag.create!(name: tag, importance: 5, user_id: user_id)
      self.save
    end
  end

  def update_tag(tag, user_id)
    if Tag.exists?(name: tag, user_id: user_id)
      self.update(tag_id: Tag.find_by(name: tag, user_id: user_id).id)
    else
      self.tag = Tag.create!(name: tag, importance: 5, user_id: user_id)
      self.save
    end
  end

  def update_second(tag, tag_id, user_id)
    if Second.exists?(name: tag, tag_id: tag_id)
      self.update(second_id: Second.find_by(name: tag, tag_id: tag_id).id, user_id: user_id)
    else
      self.second = Second.create!(name: tag, tag_id: tag_id, user_id: user_id)
      self.save
    end
  end

  def add_second(name, tag_id, user_id)
    if Second.exists?(name: name, tag_id: tag_id)
      self.update(second_id: Second.find_by(name: name, tag_id: tag_id).id, user_id: user_id)
      self.save
    else
      self.second = Second.create!(name: name, tag_id: tag_id, user_id: user_id)
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
    if(time_since_last_seen <= 3)
      self.importance * time_since_last_seen
    else
      self.importance * (time_since_last_seen * (time_since_last_seen - 2))
    end
  end

  def self.get_most_urgent
    Note.where("seentoday = false").sort_by{|i| - i.urgency}.first
  end

  def mark_as_seen(format = nil)
    if self.importance > 2
      self.update(importance: self.importance - (rand(2) + 1))
    end
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
