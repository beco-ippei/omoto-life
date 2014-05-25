class Item < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :photos

  #TODO reorder を使う必要が出てくるので注意
  #default_scope -> { order(:id) }

  def hex_id
    id.blank? ? nil : id.to_s(16)
  end

  def add_photo(photo)
    photo.user_id = self.user_id
    photo.item_id = self.id

    photo.create_and_convert_image

    photo.save!
  end

  private

  # return crop-required-size or nil (crop not necessary)
  #def _calculate_cropped_size(height, width, max_side_length)
  #  return nil if height.nil? || width.nil?
  #  return nil if height <= max_side_length && width <= max_side_length

  #  if max_side_length < height && width <= max_side_length
  #    w = width * (max_side_length.to_f / height)
  #    h = max_side_length
  #  end

  #  [h.to_i, w.to_i]
  #end
end
