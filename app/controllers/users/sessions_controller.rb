class Users::SessionsController <Devise::SessionsController
#	before_filter :authenticate_time, :only => 'create'

	def new
		super
	end
	def create
		super
	end

	def destroy
		super
	end
=begin
	private
	def authenticate_time
		expiration_time=[current_user.add_start, current_user.add_end]
		current_time=Time.now
		if current_time.between?(expiration_time[0], expiration_time[0])
		else
			redirect_to destroy_user_session_path
		end
	end
=end
end
