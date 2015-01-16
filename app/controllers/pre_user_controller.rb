class PreUserController < ApplicationController
    def create
        flash[:errors]=[]

        p=params[:pre_user].permit(:name, :email, :user_type)
        @pre_user=PreUser.new(p)
        @pre_user.expired_time=Time.now+7*24*60*60

        if @pre_user.name.nil? || @pre_user.email.nil?
            flash[:errors]<<'Complete data required'
        else
            respond_to do |format|
            if @pre_user.save
                AutoMail.auto_mail(@pre_user).deliver

                format.html{redirect_to users_path, notice: 'Invitation has successfully sent.'}
                format.json{render json: @pre_user}
            else
                format.html{render :new}
                format.json{render json: @pre_user.errors, status: :unprocessable_entity}
            end
            end
        end
    end
end
