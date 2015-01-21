class Users::SessionsController < Devise::SessionsController
    def new
        super
    end
    def create
        user=User.find_by_email(params[:user][:email])
        if user.user_type=='daypass'||user.user_type=='guest'
            self.destroy
            flash[:notice]='I am sorry. This is for admin page. Go to Enter page.'
        else
            super
        end
    end
    def destroy
        super
    end
end