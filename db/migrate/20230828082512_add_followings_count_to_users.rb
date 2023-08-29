class AddFollowingsCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :followings_count, :integer, null: false, default: 0

    User.find_each do |user|
      user.update! followings_count: user.followings.size
    end
  end
end
