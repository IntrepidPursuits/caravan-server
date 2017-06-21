def load_fixture(filename)
  File.read(Rails.root.join("spec", "fixtures", filename))
end
