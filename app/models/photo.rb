class Photo < ActiveRecord::Base
  belongs_to :item
  belongs_to :user

  attr_accessor :file, :temp_file

  validate :_valid_file?, if: -> { file }

  def tempfile_path
    "/images/tmp/#{Pathname.new(@temp_file).basename}"
  end

  def create_tempfile
    temp_file = Tempfile.new(['upload', '.jpg'], './public/images/tmp')
    @temp_file = temp_file.path

    img = Magick::Image.read(file.path).first
    if img.rows > 2000 || img.columns > 2000
      # これから縮小指定される可能性もあるので大きめにしておく
      img.resize_to_fit! 2000
    end
    img.auto_orient!

    img.write @temp_file
    true
  rescue => e
    logger.error e.backtrace.join "\n"
    false
  end

  def create_and_convert_image
    #TODO: 適当な暗号っぽいファイル名を作る
    #TODO 画像処理は非同期実行するとかだと良さそうな気がする
    #TODO: ファイルは会員IDのDIRに入れると良さそう
    new_file_path = "/usr/share/nginx/images/#{user_id.to_s(16)}"
    FileUtils.mkdir_p new_file_path

    self.id = sequence_nextval
    self.path = (item_id * 100_000 + id).to_s(16)

    #TODO magick number of 1024
    max_size = 1024
    img = Magick::Image.read(@temp_file).first
    if img.rows > max_size || img.columns > max_size
      img.resize_to_fit! max_size
    end
    img.strip!
    #TODO should move to Image.class
    write_image img, "#{new_file_path}/#{self.path}.jpg"

    # make thumbnail
    x, y = [img.columns, img.rows]
    mx = my = 320
    my = my * (y.to_f / x) if x > y
    mx = mx * (x.to_f / y) if x < y
    img.thumbnail! mx.to_i, my.to_i
    write_image img, "#{new_file_path}/#{self.path}_s.jpg"
  end

  private

  def _valid_file?
    if file.content_type != 'image/jpeg'
      self.errors[:file] << 'photo-file should jpeg'
    end
  end

  def sequence_nextval
    next_seq = self.connection.execute("SELECT nextval('photos_id_seq')")
    next_seq[0]['nextval']
  end

  def write_image(img, path)
    img.write path
    FileUtils.chmod 0664, path
  end

  def file_path=(value)
    if File.exist? value
      @temp_file = value
    end
  end
end
