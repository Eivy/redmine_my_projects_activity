# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
	get 'my/activity', :to => 'my_activity#index'
end
