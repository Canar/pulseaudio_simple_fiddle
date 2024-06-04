Gem::Specification.new do |s|
  s.name        = 'pulseaudio_simple_fiddle'
  s.version     = '0.0.0'
  s.summary     = 'A Ruby-Fiddle implementation of the PulseAudio Simple API.'
  s.description = s.summary
  s.author      = 'Benjamin Cook'
  s.email       = 'root@baryon.it'
  s.files       << 'lib/pulseaudio_simple_fiddle.rb'
  s.homepage    = 'https://github.com/Canar/pulseaudio_simple_fiddle'
  s.add_runtime_dependency 'fiddle'
  s.required_ruby_version = '>= 2.5'
end
