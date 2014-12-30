class Users::RegistrationsController <Devise::RegistrationsController

  #filter logged in or not before going any page
  before_filter :authenticate_user!
	def index
		#show all users if superadmin
		if current_user.user_type=='superadmin'
			@users=User.all
		else
		#show current user's status if not superadimin
			@users=[current_user]
		end

	end

	def new
		super
	end
	def create
		super
	end

	def edit
		super
	end
	def update
		super
	end
=begin
	private
	def user_params
		params[:user].permit(user_events_attributes: [:name, :email, :phone])
	end
	def set_user
		@user=User.find(params[:id])
	end
=end
end
