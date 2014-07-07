class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_filter :require_login, only: [:new, :upload, :create]
  #TODO: authentication filter for upload

  def index
    @items = Item.all.eager_load(:photos).order(:id)
  end

  def show
    @new_comment = Comment.new
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id

    #@photo = Photo.new temp_file: params[:temp_file]

    @item.save!
    redirect_to @item, notice: 'Item was successfully created.'

#    @item.transaction do
#      #if !File.exist? @photo.temp_file
#      #  render action: 'new', notice: 'temp image file not found'
#      #else
#        @item.save!
#
##        @item.add_photo @photo
#        redirect_to @item, notice: 'Item was successfully created.'
#      #end
#    end

  rescue => e
    logger.error e.message
    logger.error e.backtrace.join "\n"
    render action: 'new', notice: 'failed to register item'
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
    params.require(:item).permit(:title, :description, :breed)
  end

  #TODO: should imple filter item owner
end
