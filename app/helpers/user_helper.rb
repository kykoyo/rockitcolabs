module UserHelper
    def custom_sort(user_type)
        if user_type=='superadmin'
            return 1
        elsif user_type=='member'
            return 2
        elsif user_type=='instructor'
            return 3
        elsif user_type=='guest'
            return 4
        else
            return 5
        end
    end
end
