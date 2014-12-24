class EventsController < ApplicationController
	def new
		@event=Event.new
		@user_event=UserEvent.new
	end
	def create
		p=params[:event].permit(:title, :description)
		@event=Event.new(p)

		q=params[:event].permit(:id, :user)
		@user_event=UserEvent.new(q)
		@user_event.save

		#needed_id=params[:event][:user]
		#user_obj=User.find(needed_id)
		#@event.user=user_obj

		@event.save
		render 'show'
	end

	def show
		@events=Event.all
	end


end
