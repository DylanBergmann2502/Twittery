class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    following_users = current_user.following_users
    @tweets = Tweet.includes(:liking_users, :bookmarking_users, :retweeting_users, :user).where(user_id: following_users).order(created_at: :desc).map do |tweet|
      TweetPresenter.new(tweet: tweet, current_user: current_user)
    end
  end
end
