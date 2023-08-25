class Tweet < ApplicationRecord
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
  belongs_to :parent_tweet, class_name: "Tweet", optional: true

  validates :body, presence: true, length: { maximum: 280 }
end
