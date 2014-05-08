class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessor :password_confirmation

  has_many :items
  has_many :comments

  def hex_id
    id.blank? ? nil : id.to_s(16)
  end
end
