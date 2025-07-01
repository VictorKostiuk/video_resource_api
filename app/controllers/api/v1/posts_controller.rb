class Api::V1::PostsController < ApplicationController
  before_action :find_post, only: [ :show, :update, :destroy ]
  def index
    @posts = Post.all
    render json: @posts, each_serializer: PostSerializer
  end

  def show
    render json: { post: @post }, status: :ok
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      render json: { post: @post }, status: :created
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: { post: @post }, status: :ok
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      render json: { post: @post }, status: :ok
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :thumbnail, :video, :channel_id)
  end
end
