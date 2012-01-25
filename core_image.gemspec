Gem::Specification.new do |spec|
  spec.name         = "core_image"
  spec.version      = "0.0.2"
  spec.date         = "2012-01-24"
  spec.summary      = "Manipulate images via Apple's Core Image technology"
  spec.description  = "Simple image manipulation using Apple's Core Image technology. Scale, rotate, flip, convert, overlay, and more."
  spec.author       = "Spencer Rogers"
  spec.email        = "SpencerRogers@gmail.com"  
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = ['test/core_image_test.rb']
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency "rubygems"
  spec.add_development_dependency "riot"
  spec.homepage     = "https://github.com/serogers"
  spec.requirements << ["Mac OS X"]
end