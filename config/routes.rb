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
      resources :statuses, only: [:create]
    end
    resources :signups, only: [:create]
    resources :trips, only: [:create, :show] do
      resources :locations, only: [:index]
    end
  end
end
