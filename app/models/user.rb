class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  has_many :notes
  has_many :tags
  has_many :seconds
  after_create :fill_db

  def tags_in_order_of_most_used
    tags.all.sort_by{|i| - i.note_count}
  end

  def fill_db
  end
end
