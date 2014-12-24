class EventsController < ApplicationController
	def new
		@event=Event.new
	end

        def index
          @events = Event.all
        end
        
	def create
	  p=params[:event].permit(:title, :description)
	  @event=Event.new(p)


	  needed_id=params[:event][:users]
	  user_obj=User.find(needed_id)

          # This user is the owner of the event.
	  @event.owner=user_obj

          # Take all the lines in the results of the text area tag
          all_lines = something

          # all_lines  should be an array
          # For each line:
          all_lines.each do |line|
            email=something # get email from line somehow
            # if there is a user by that email - associate that user to the event
            user_obj = something
            # else create a user and associate to that user.
            if user_obj != nil then
              # There is such a user
            else
              # No user with that email
            end
          end
          
	  @event.save

          # Do something after creating the event
          render 'show' # meaning: use the show view in the views/events folder
	end

	def show
          #	  @events=Event.all
          @event = Event.find(params[:id])
	end


end
