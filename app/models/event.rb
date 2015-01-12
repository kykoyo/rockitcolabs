class Event < ActiveRecord::Base
  has_many :user_events
  has_many :users, through: :user_events

  # More readable alternative to belongs_to :user
  belongs_to :owner, class_name: 'User'
end
