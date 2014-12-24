#coding: utf-8

User.create(:name =>'Bob', :email=>'bob@bob.com', :user_type=>'superadmin', :phone => 4151234567, :password => 'aaaaaaaa')
User.create(:name =>'Anthony', :email => 'anthony@anthony.com', :user_type => 'admin', :phone => 4152345678, :password => 'aaaaaaab')
User.create(:name =>'George', :email =>'george@george.com', :user_type =>'member', :phone =>4153456789, :password => 'aaaaaaac')

Event.create(:title =>'class1', :description =>'the first class', :start =>Time.new(2014,12,23,13,0,0), :end =>Time.new(2014,12,23,14,0,0))
Event.create(:title =>'class2', :description =>'the second class', :start =>Time.new(2014,12,24,13,0,0), :end =>Time.new(2014,12,24,14,0,0))
Event.create(:title =>'class3', :description =>'the third class', :start =>Time.new(2014,12,25,15,0,0), :end =>Time.new(2014,12,25,16,0,0))
