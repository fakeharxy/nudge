class Complete < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :tag
  belongs_to :second
end
