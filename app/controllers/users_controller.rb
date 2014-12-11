class UsersController < ApplicationController
	def index
		@users=User.all
	end
	def show
		@user=User.find(params[:id])
		@event=Event.all
	end

	private

	def project_params
		params[:user].permit(:name, :email, :phone)
	end

end
