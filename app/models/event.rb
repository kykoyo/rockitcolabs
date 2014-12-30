class Event < ActiveRecord::Base
  has_many :user_events
  has_many :users, through: :user_events

  # More readable alternative to belongs_to :user
  belongs_to :owner, class_name: 'User'
=begin
  validates presence: true, if: :collect_format?
  
  def collect_format?
  	if data.count==3 && data[0].include?('@')
  		return true
  	else
  		return false
  	end
  end
=end

end
