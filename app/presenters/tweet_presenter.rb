class TweetPresenter
  include ActionView::Helpers::DateHelper
  include Rails.application.routes.url_helpers

  def initialize(tweet:, current_user:, tweet_activity: nil)
    @tweet = tweet
    @current_user = current_user
    @tweet_activity = tweet_activity
  end

  attr_reader :tweet, :current_user, :tweet_activity

  delegate :user, :likes_count, :retweets_count, :replies_count, :views_count, to: :tweet
  delegate :display_name, :username, :avatar, to: :user

  def tweet_activity_html
    case tweet_activity&.verb
    when "liked"
      "<p class=\"fw-bold fs-6 mb-0 text-muted\" style=\"margin-left: 5rem; font-size: 12px !important;\">#{tweet_activity.actor.display_name} liked</p>"
    when "replied"
      "<p class=\"fw-bold fs-6 mb-0 text-muted\" style=\"margin-left: 5rem; font-size: 12px !important;\">#{tweet_activity.actor.display_name} replied to</p>"
    when "retweeted"
      "<p class=\"fw-bold fs-6 mb-0 text-muted\" style=\"margin-left: 5rem; font-size: 12px !important;\">#{tweet_activity.actor.display_name} retweeted</p>"
    else
      ""
    end
  end

  def created_at
    if (Time.zone.now - tweet.created_at) > 1.day
      tweet.created_at.strftime("%b %-d")
    else
      time_ago_in_words(tweet.created_at)
    end
  end

  def body_html(p_class: "")
    texts = tweet.body.split(" ").map do |word|
      if word.include?("#")
        "<a class=\"twitter-link\">#{word}</a>"
      elsif word.include?("@")
        "<a class=\"twitter-link\">#{word}</a>"
      else
        word
      end
    end
    "<p class=\"#{p_class}\">#{texts.join(" ")}</p>"
  end

  def avatar
    return user.avatar if user.avatar.present?
    ActionController::Base.helpers.asset_path("user.png")
  end

  ########################################################################
  # Like Presenter
  def like_tweet_url(source: "tweet_card")
    if tweet_liked_by_current_user?
      tweet_like_path(tweet, current_user.likes.find_by(tweet: tweet), source: source)
    else
      tweet_likes_path(tweet, source: source)
    end
  end

  def like_turbo_data_method
    if tweet_liked_by_current_user?
      "delete"
    else
      "post"
    end
  end

  def like_image
    if tweet_liked_by_current_user?
      "heart-filled.png"
    else
      "heart-unfilled.png"
    end
  end

  ########################################################################
  # Bookmark Presenter
  def bookmark_tweet_url(source: "tweet_card")
    if tweet_bookmarked_by_current_user?
      tweet_bookmark_path(tweet, current_user.bookmarks.find_by(tweet: tweet), source: source)
    else
      tweet_bookmarks_path(tweet, source: source)
    end
  end

  def bookmark_turbo_data_method
    if tweet_bookmarked_by_current_user?
      "delete"
    else
      "post"
    end
  end

  def bookmark_image
    if tweet_bookmarked_by_current_user?
      "bookmark-filled.png"
    else
      "bookmark-unfilled.png"
    end
  end

  def bookmark_text
    if tweet_bookmarked_by_current_user?
      "Bookmarked"
    else
      "Bookmark"
    end
  end

  ########################################################################
  # Retweet Presenter
  def retweet_tweet_url(source: "tweet_card")
    if tweet_retweeted_by_current_user?
      tweet_retweet_path(tweet, current_user.retweets.find_by(tweet: tweet), source: source)
    else
      tweet_retweets_path(tweet, source: source)
    end
  end

  def retweet_turbo_data_method
    if tweet_retweeted_by_current_user?
      "delete"
    else
      "post"
    end
  end

  def retweet_image
    if tweet_retweeted_by_current_user?
      "retweet-filled.png"
    else
      "retweet-unfilled.png"
    end
  end

  private

  def tweet_liked_by_current_user
    @tweet_liked_by_current_user ||= tweet.liking_users.include?(current_user)
  end
  alias tweet_liked_by_current_user? tweet_liked_by_current_user

  def tweet_bookmarked_by_current_user
    @tweet_bookmarked_by_current_user ||= tweet.bookmarking_users.include?(current_user)
  end
  alias tweet_bookmarked_by_current_user? tweet_bookmarked_by_current_user

  def tweet_retweeted_by_current_user
    @tweet_retweeted_by_current_user ||= tweet.retweeting_users.include?(current_user)
  end
  alias tweet_retweeted_by_current_user? tweet_retweeted_by_current_user
end
