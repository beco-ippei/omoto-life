class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]
  before_action :set_item

  def show
    @photos = @item.photos
  end

  def new
    @photo = Photo.new
  end

  def upload
    @photo = Photo.new file: params[:file]

    unless @photo.valid? && @photo.create_tempfile
      @photo.errors << '写真アップロードエラー'
      render :new, notice: 'upload failed'
    end
  end

  def create
    @photo = Photo.new(photo_params)
    #@photo[:temp_file] = params[:temp_file]

    if File.exist? @photo.temp_file
      @item.add_photo @photo
      redirect_to @item
    else
      render action: 'new', notice: 'temp image file not found'
    end
  end

  def edit
  end

  def update
  end

  def destory
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def photo_params
    params.permit :item_id, :user_id, :path, :description, :taken_at, :temp_file
  end
end
