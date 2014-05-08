class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  #TODO: authentication filter for upload

  def index
    @items = Item.all
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

    require 'tempfile'    #TODO remove
    require 'pathname'
    require 'fileutils'

    temp_file = Tempfile.new(['upload', '.jpg'], './public/images/tmp')

    # move or set $TMP = ./tmp ? TODO
    FileUtils.mv(file.path, temp_file.path)
    #TODO この時点でExif見て回転とかする？
    #TODO 最低限の画像縮小とかしてもいいかも。

    @item = Item.new(path: Pathname.new(temp_file.path).basename)
  end

  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id

    temp_file = "./public/images/tmp/#{@item.path}"

    if @item.save
      #TODO: ファイルは会員IDのDIRに入れると良さそう
      #TODO: 適当な暗号っぽいファイル名を作る

      @item.path = @item.hex_id + '.jpg'
      @item.save      #TODO 適当に。

      #TODO 画像処理は非同期実行するとかだと良さそうな気がする
      #TODO ImageMagick などで少しいじる。サムネ画像とかあると良さそう
      new_file_path = "/usr/share/nginx/images/#{current_user.hex_id}"
      FileUtils.mkdir_p new_file_path
      FileUtils.mv(temp_file, "#{new_file_path}/#{@item.path}")
      FileUtils.chmod(0664, "#{new_file_path}/#{@item.path}")

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
end
