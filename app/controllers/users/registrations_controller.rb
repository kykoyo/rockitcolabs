class Users::RegistrationsController <Devise::RegistrationsController
	def index
		@users=User.all
	end


	def new
		super
	end
	def create
		super
		@user=User.new(user_params)
	end

	def edit
		super
	end
	def update
		super
	end

	private

	def project_params
		params[:user].permit(:name, :email, :phone)
	end

	def set_user
		@user=User.find(params[:id])
	end


end
