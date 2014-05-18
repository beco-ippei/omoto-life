class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_filter :require_login, only: [:new, :upload, :create]
  #TODO: authentication filter for upload

  def index
    @items = Item.all.order(:id)
  end

  def show
    @new_comment = Comment.new
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def upload
    #TODO restruct to model
    file = params[:file]
    if file.content_type != 'image/jpeg'
      #TODO: should validate
    end

    temp_file = Tempfile.new(['upload', '.jpg'], './public/images/tmp')

    img = Magick::Image.read(file.path).first
    if img.rows > 2000 || img.columns > 2000
      # これから縮小指定される可能性もあるので大きめにしておく
      img.resize_to_fit! 2000
    end
    img.auto_orient!

    img.write temp_file.path

    #TODO remove geolocation ?

    @item = Item.new(path: Pathname.new(temp_file.path).basename)
  end

  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id

    temp_file = "./public/images/tmp/#{@item.path}"
    if !File.exist? temp_file
      render action: 'new', notice: 'temp image file not found'
    elsif @item.save
      #TODO: ファイルは会員IDのDIRに入れると良さそう
      #TODO: 適当な暗号っぽいファイル名を作る

      @item.path = @item.hex_id
      @item.save      #TODO 適当に。

      #TODO 画像処理は非同期実行するとかだと良さそうな気がする
      #TODO ImageMagick などで少しいじる。サムネ画像とかあると良さそう
      new_file_path = "/usr/share/nginx/images/#{current_user.hex_id}"
      FileUtils.mkdir_p new_file_path

      #TODO magick number of 1024
      max_size = 1024
      img = Magick::Image.read(temp_file).first
      if img.rows > max_size || img.columns > max_size
        img.resize_to_fit! max_size
      end
      img.strip!
      #TODO should move to Image.class
      write_image img, "#{new_file_path}/#{@item.path}.jpg"

      # make thumbnail
      x, y = [img.columns, img.rows]
      mx = my = 320
      my = my * (y.to_f / x) if x > y
      mx = mx * (x.to_f / y) if x < y
      img.thumbnail! mx.to_i, my.to_i
      write_image img, "#{new_file_path}/#{@item.path}_s.jpg"

      redirect_to @item, notice: 'Item was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params     # Strong parameters
    params.require(:item).permit(:title, :path, :description, :breed)
  end

  def write_image(img, path)
    img.write path
    FileUtils.chmod 0664, path
  end

  #TODO: should imple filter item owner
end
