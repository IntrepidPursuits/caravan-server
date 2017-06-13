Rails.application.routes.draw do
  api_version(module: "Api::V1",
                 path: { value: "api/v1" },
                 header: {
                   name: "Accept",
                   value: "application/vnd.caravan-server.com; version=1" },
                   defaults: { format: :json }) do
    resources :auths, only: [:create]
    resources :users, only: [:create, :show]
    resources :google_identities, only: [:create]
  end
  resources :users, only: [:create]
  resources :google_identities, only: [:create]
end
