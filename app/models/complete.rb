class Complete < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :tag
  belongs_to :second

  def self.in_order_of_completion(user)
    Complete.order(:created_at)
  end

  def destroy_with_tags
    oldtag_id = tag_id
    oldsecond_id = second_id
    destroy
    Tag.find_by(id: oldtag_id).destroy if Tag.find_by(id: oldtag_id).notes == []
    Second.find_by(id: oldsecond_id).destroy if Second.find_by(id: oldsecond_id).notes == []
  end

  def get_tag_name
    self.tag.name
  end
end
