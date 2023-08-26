class AddRepliesCountToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :replies_count, :integer, null: false, default: 0

    Tweet.find_each do |tweet|
      tweet.update! replies_count: tweet.reply_tweets.size
    end
  end
end
