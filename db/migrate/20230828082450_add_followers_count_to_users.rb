class AddFollowersCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :followers_count, :integer, null: false, default: 0

    User.find_each do |user|
      user.update! followers_count: user.followers.size
    end
  end
end
