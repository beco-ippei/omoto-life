class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessor :password_confirmation

  has_many :items

  def hex_id
    id.blank? ? nil : id.to_s(16)
  end
end
