class Users::SessionsController <Devise::SessionsController
	#filter logged in or not before going any page
  	before_filter :authenticate_user!, :except => [:new]

	def new
		super
	end
	def create
		super
	end

end
