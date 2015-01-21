class Users::RegistrationsController < Devise::RegistrationsController
    def new
        super
    end
    def create
        super
    end
    def edit
        @user=User.find_by_params(params[:id])
        super
    end
    def update
        super
    end

end
