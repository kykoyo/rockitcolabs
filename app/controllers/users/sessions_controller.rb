class Users::SessionsController < Devise::SessionsController
    def new
        self.resource=resource_class.new(sign_in_params)       
        super
    end
    def create
        user=User.find_by_email(params[:user][:email])
        if user.user_type!='instructor'&&user.user_type!='member'&&user.user_type!='superadmin'
            self.destroy
            flash[:notice]='I am sorry. This is for admin page. Go to Enter page.'
        elsif user.add_start!=nil && user.add_start>=Time.now
            self.destroy
            flash[:notice]='You are unavailable to log in right now.'
        elsif user.add_end!=nil && user.add_end<=Time.now
            self.destroy
            flash[:notice]='You are unavailable to log in right now.'
        else
            super
        end
    end
    def destroy
        super
    end
end