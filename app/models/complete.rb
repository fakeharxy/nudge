class Complete < ApplicationRecord
  belongs_to :user, optional: true

  def self.in_order_of_completion(user)
    Complete.where(user_id: user).order(:created_at)
  end

  def destroy_with_tags
    destroy
  end

  def get_tag_name
    self.tag
  end
end
