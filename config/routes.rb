Rails.application.routes.draw do
  api_version(module: "Api::V1",
                 path: { value: "api/v1" },
                 header: {
                   name: "Accept",
                   value: "application/vnd.caravan-server.com; version=1" },
                   defaults: { format: :json }) do
    resources :auths, only: [:create]

    constraints AuthenticatedConstraint.new do
      resources :cars, only: [:create, :show] do
        resource :leave, only: [:update], controller: :leave_car
        resources :locations, only: [:create]
        resource :status, only: [:update], controller: :car_status
      end
      resources :signups, only: [:create, :update]
      resources :trips, only: [:create, :show] do
        resource :leave, only: [:destroy], controller: :leave_trip
        resources :locations, only: [:index]
        resources :stops, only: [:create]
      end
      resources :users, only: [] do
        resources :trips, only: [:index]
      end
    end
  end
end
