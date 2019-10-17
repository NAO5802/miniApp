class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index
  # before_action :move_to_index , only: [:create, :update, :destroy]    これを設定していたため、投稿・編集・削除ができなかった

  def index
    @posts = Post.includes(:user).order("created_at DESC").page(params[:page]).per(5)
  end

  def new
    @post = Post.new
  end
  
  def create
    Post.create(text: post_params[:text], user_id: current_user.id)
    move_to_index
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    post.update(post_params) if post.user_id == current_user.id
    move_to_index
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy if post.user_id == current_user.id
    move_to_index
  end

  private
  def post_params
    params.require(:post).permit(:text)
  end

  def move_to_index
    redirect_to action: :index
  end


end
