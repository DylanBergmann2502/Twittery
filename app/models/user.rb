class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Associations
  has_one_attached :avatar
  has_many :tweets, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_tweets, through: :bookmarks, source: :tweet

  has_many :retweets, dependent: :destroy
  has_many :retweeted_tweets, through: :retweets, source: :tweet

  has_many :views
  has_many :viewed_tweets, through: :views, source: :tweet

  has_many :followings, dependent: :destroy
  has_many :following_users, through: :followings, source: :following_user
  # Have to create a reverse following relationship, if not,
  # it will join on the user_id instead of following_user_id
  has_many :reverse_followings, foreign_key: :following_user_id, class_name: "Following"
  has_many :followers, through: :reverse_followings, source: :user

  has_many :messages
  has_and_belongs_to_many :message_threads

  has_many :notifications, dependent: :destroy

  # Validations
  validates :username, uniqueness: { case_sensitive: false }, allow_blank: true

  # Callbacks
  before_save :set_display_name, if: -> { username.present? && display_name.blank? }

  def set_display_name
    self.display_name = username.humanize
  end
end
