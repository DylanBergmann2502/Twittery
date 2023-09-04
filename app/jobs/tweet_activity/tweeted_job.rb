class TweetActivity::TweetedJob < ApplicationJob
  queue_as :default

  def perform(actor:, tweet:)
    # This query will perform thousands of operations
    # actor.followers.each do |follower|
    #   TweetActivity.create(user: follower, actor: actor, tweet: tweet, verb: "tweeted")
    # end

    tweet_activities = actor.followers.map do |follower|
      TweetActivity.new(user: follower, actor: actor, tweet: tweet, verb: "tweeted")
    end

    # This will instead do just one operation
    TweetActivity.import tweet_activities, on_duplicate_key_ignore: true, batch_size: 500
  end
end
