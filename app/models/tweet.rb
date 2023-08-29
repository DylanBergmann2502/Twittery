class Tweet < ApplicationRecord
  HASHTAG_REGEX = /(#\w+)/

  # Associations
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarking_users, through: :bookmarks, source: :user

  has_many :retweets, dependent: :destroy
  has_many :retweeting_users, through: :retweets, source: :user

  has_many :views, dependent: :destroy
  has_many :viewing_users, through: :views, source: :user

  has_many :reply_tweets, class_name: "Tweet", foreign_key: :parent_tweet_id, inverse_of: :parent_tweet
  belongs_to :parent_tweet, class_name: "Tweet", optional: true, counter_cache: :replies_count

  has_and_belongs_to_many :hashtags

  #Validations
  validates :body, presence: true, length: { maximum: 280 }

  # Callbacks
  before_save :parse_and_save_hashtags

  def parse_and_save_hashtags
    matches = body.scan(HASHTAG_REGEX)
    return if matches.empty?

    matches.flatten.each do |tag|
      Hashtag.find_or_create_by(tag: tag.delete("#"))
    end
  end
end
