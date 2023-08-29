class ProfileController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @tweet_presenter = @user.tweets.map do |tweet|
      TweetPresenter.new(tweet: tweet, current_user: @user)
    end
    render "users/show"
  end

  def update
    @user = current_user
    @user.update(user_params[:password].blank? ? user_params.except(:password) : user_params)
    respond_to do |format|
      format.html { redirect_to profile_path }
      format.turbo_stream
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :display_name, :email, :password, :location, :bio, :profile_url)
  end
end
