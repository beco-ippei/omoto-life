module ItemsHelper
  def image_path(item)
    #TODO should be in config
    "//img.beco-ippei.net/#{item.user.hex_id}/#{item.path}"
  end
end
