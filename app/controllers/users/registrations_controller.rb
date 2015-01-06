class Users::RegistrationsController <Devise::RegistrationsController

	def index
		if current_user==nil
			redirect_to root_path
		#show all users if superadmin
		elsif current_user.user_type=='superadmin'
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
	def show
		
	end
	def day_pass

	end

end
