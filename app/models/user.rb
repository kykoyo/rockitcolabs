class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # When a user is deleted, their participation must be deleted.
  has_many :user_events, dependent: :destroy
  # When a user is deleted, note that events they participate in must NOT be deleted.
  has_many :events, through: :user_events

  # When a user is deleted, events owned by them must be deleted.
  has_many :created_events, class_name: 'Event', foreign_key: :owner_id, dependent: :destroy
  def password_required?
    super if confirmed?
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end
end
