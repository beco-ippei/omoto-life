class Item < ActiveRecord::Base
  attr_accessor :file

  belongs_to :user
  has_many :comments

  def hex_id
    id.blank? ? nil : id.to_s(16)
  end
end
