class Complete < ApplicationRecord
  belongs_to :user_id
  belongs_to :tag_id
  belongs_to :second_id
end
