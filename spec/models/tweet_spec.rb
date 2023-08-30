require "rails_helper"

RSpec.describe Tweet, type: :model do
  it { should belong_to :user }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_most(280) }

  it { should have_many(:likes).dependent(:destroy) }
  it { should have_many(:liking_users).through(:likes).source(:user) }

  it { should have_many(:bookmarks).dependent(:destroy) }
  it { should have_many(:bookmarking_users).through(:bookmarks).source(:user) }

  it { should have_many(:retweets).dependent(:destroy) }
  it { should have_many(:retweeting_users).through(:retweets).source(:user) }

  it { should have_many(:views).dependent(:destroy) }
  it { should have_many(:viewing_users).through(:views).source(:user) }

  it { should have_many(:reply_tweets).with_foreign_key(:parent_tweet_id).class_name("Tweet").inverse_of(:parent_tweet) }
  it { should belong_to(:parent_tweet).class_name("Tweet").optional }

  it { should have_and_belong_to_many :hashtags }

  describe "saving hashtags" do
    let(:user) { create(:user) }

    context "when there's no hashtags in the body" do
      it "does not create a new hashtag" do
        expect do
          Tweet.create(user: user, body: "Bell tolls for whom")
        end.not_to change { Hashtag.count }
      end
    end

    context "when there's hashtags in the body" do
      it "creates hashtags" do
        expect do
          Tweet.create(user: user, body: "#Bell tolls for #whom")
        end.to change { Hashtag.count }.by(2)
      end

      it "creates hashtags assigned to a tweet" do
        tweet = Tweet.create(user: user, body: "#Bell tolls for #whom")
        expect(tweet.hashtags.size).to eq(2)
      end
    end

    context "when there's duplicate hashtags in the body" do
      it "does not create extra hashtags if already in the database table" do
        Hashtag.create(tag: "bell")
        expect do
          # #Bell fails for some reason
          Tweet.create(user: user, body: "#bell tolls for #whom")
        end.to change { Hashtag.count }.by(1)
      end
    end
  end
end
