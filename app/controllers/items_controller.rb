class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = Item.all
  end

  def show
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def upload
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

    @item = Item.new(path: Pathname.new(temp_file.path).basename)
  end

  def create
    @item = Item.new(item_params)
    temp_file = "./public/images/tmp/#{@item.path}"

    if @item.save
      #TODO: ファイルは会員IDのDIRに入れると良さそう
      #TODO: 適当な暗号っぽいファイル名を作る
      #user_key = 13210
      user_id = 1.to_s(16)   #TODO temp
      #file_key = 3243732597132
      #file_name = (file_key - user_id + @item.id).to_s(30) + '.jpg'

      @item.path = @item.id.to_s(16) + '.jpg'
      @item.save      #TODO 適当に。

      new_file_path = "/usr/share/nginx/images/#{user_id}"
      FileUtils.mkdir_p new_file_path
      FileUtils.mv(temp_file, "#{new_file_path}/#{@item.path}")
      FileUtils.chmod(0664, "#{new_file_path}/#{@item.path}")

      redirect_to @item, notice: 'Item was successfully created.'
    else
      render action: 'new'
    end

    #respond_to do |format|
    #  if @item.save
    #    format.html { redirect_to @item, notice: 'Item was successfully created.' }
    #    format.json { render action: 'show', status: :created, location: @item }
    #  else
    #    format.html { render action: 'new' }
    #    format.json { render json: @item.errors, status: :unprocessable_entity }
    #  end
    #end
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:title, :path, :description, :breed)
    end
end
