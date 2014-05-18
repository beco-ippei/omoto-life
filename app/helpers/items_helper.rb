module ItemsHelper
  def image_path(item)
    #TODO should be in config
    "//img.beco-ippei.net/#{item.user.hex_id}/#{item.path}.jpg"
  end

  def thumbnail_path(item)
    #TODO should be in config
    "//img.beco-ippei.net/#{item.user.hex_id}/#{item.path}_s.jpg"
  end
end
