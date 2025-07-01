class Api::V1::ChannelsController < ApplicationController
  before_action :find_channel, only: [ :show, :update, :destroy ]

  def index
    @channels = Channel.includes(:posts)
    render json: @channels, each_serializer: ChannelSerializer
  end

  def show
    render json: @channel
  end
  def create
    @channel = current_user.channels.build(channel_params)

    if @channel.save
      render json: { channel: @channel }, status: :created
    else
      render json: { errors: @channel.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @channel.update(channel_params)
      render json: { channel: @channel }, status: :ok
    else
      render json: { errors: @channel.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @channel.destroy
      render json: { message: "Channel was successfully destroyed!" }, status: :ok
    else
      render json: { errors: @channel.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_channel
    @channel = Channel.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Channel not found" }, status: :not_found
  end

  def channel_params
    params.require(:channel).permit(:title, :description)
  end
end
