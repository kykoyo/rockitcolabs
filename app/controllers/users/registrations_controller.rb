class Users::RegistrationsController < Devise::RegistrationsController
    before_filter :require_no_authentication, only: :cancel

    def create
        super
    end
    def edit
        super
    end
    def update
        super
    end

    # private

    # def check_hidden_token
    #     hidden_token=params[:hidden_token]
    #     @pre_user=PreUser.find_by_hidden_token(hidden_token)
    #     if @pre_user.nil?
    #     else
    #         flash[:errors]='Something went wrong. Contact RockIT CoLabs for any help.'
    #         redirect_to root_path
    #     end
    # end
end