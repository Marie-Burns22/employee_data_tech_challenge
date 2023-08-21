Rails.application.routes.draw do
  root "providers#index"
  
  get "/providers", to: "providers#index"
  get "/providers/:id", to: "providers#show" 
  get '/employees/:id', to: "employees#show"
end
