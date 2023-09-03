class Notification < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :actor, class_name: "User"
  belongs_to :tweet, optional: true

  # Enums
  VERBS = %w[followed-me liked-tweet mentioned-me].freeze
  VERBS.each do |v|
    define_method("#{v.gsub("-", "_")}?") { v == verb }
  end

  # Validations
  validates :verb, presence: true, inclusion: { in: VERBS }
end
