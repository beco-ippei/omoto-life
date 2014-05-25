module ItemsHelper
  def image_path(item)
    #TODO should be in config
    "//img.beco-ippei.net/#{item.user_id.to_s(16)}/#{item.photos.first.path}.jpg"
  end

  def thumbnail_path(item)
    #TODO should be in config
    "//img.beco-ippei.net/#{item.user_id.to_s(16)}/#{item.photos.first.path}_s.jpg"
  end
end
