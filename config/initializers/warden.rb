Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.failure_app = WardenFailureController
end
