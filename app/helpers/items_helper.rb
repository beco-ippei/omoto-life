module ItemsHelper
  #TODO 画像表示時に一緒に image_tag 相当の処理をすると良さそう
  # 画像がなければ代替HTMLのを出力するとか
  # class: 'xxxxx' とすれば、任意のスタイル適用できる
  def image_path(item)
    #TODO should be in config
    "//img.beco-ippei.net/#{item.user_id.to_s(16)}/#{item.photos.first.path}.jpg"
  end
  def photo_path(photo)
    #TODO should be in config
    "//img.beco-ippei.net/#{photo.item.user_id.to_s(16)}/#{photo.path}.jpg"
  end

  def thumbnail_path(item)
    #TODO should be in config
    "//img.beco-ippei.net/#{item.user_id.to_s(16)}/#{item.photos.first.path}_s.jpg"
  end
  def photo_thumbnail_path(photo)
    #TODO should be in config
    "//img.beco-ippei.net/#{photo.item.user_id.to_s(16)}/#{photo.path}_s.jpg"
  end
end
