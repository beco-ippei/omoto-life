class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_item, only: [:create, :destroy]
  #TODO: authentication filter for create/delete

  def index
    @comments = Comment.all
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.item = @item

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @item, notice: 'Comment was successfully createted.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @item }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def comment_params     # Strong parameters
    params.permit(:body)
  end
end
