Rails.application.routes.draw do
  api_version(module: "Api::V1",
                 path: { value: "api/v1" },
                 header: {
                   name: "Accept",
                   value: "application/vnd.caravan-server.com; version=1" },
                   defaults: { format: :json }) do
    resources :auths, only: [:create]

    resources :cars, only: [:create, :show] do
      resources :locations, only: [:create]
      resource :status, only: [:update], controller: :car_status
    end

    resources :signups, only: [:create]

    resources :trips, only: [:create, :show] do
      resources :locations, only: [:index]
    end
    
    resources :users, only: [] do
      resources :trips, only: [:index]
    end
  end
end
