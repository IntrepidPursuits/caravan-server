namespace :location_simulator do
  desc "Resets locations of cars for a demo"
  task reset_locations: :environment do
    LocationSimulator.reset_locations
  end

  desc "Simulates the locations of cars moving"
  task perform: :environment do
    LocationSimulator.perform
  end
end
