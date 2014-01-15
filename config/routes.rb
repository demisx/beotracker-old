BeoTrackerCom::Application.routes.draw do
  devise_for :users, controllers: { sessions: :sessions, confirmations: :confirmations }, skip: :registrations, path: ""
  
  get ':action' => 'static#:action'
  root 'static#index'
end
