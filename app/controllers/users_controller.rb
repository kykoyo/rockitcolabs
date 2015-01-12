class UsersController < ApplicationController
    before_filter :authenticate_user!
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


    def destroy
        @user=User.find(params[:id])
        flash[:errors]=[]
        if current_user.user_type=='superadmin'
        if @user==current_user
            flash[:errors]<<"You can't delete yourself"
        else
            @user.destroy
        end
        if @user.destroy
            redirect_to root_path, notice: "User deleted."
        end
        else
            flash[:errors]<<'Invalid user'
        end
    end

    def edit
        @user=User.find(params[:id])        
    end
    def update
        p=params[:user].permit(:name, :email, :phone, :password)
        @user.update(p)
    end
end
