require 'erb'

def render(file, binding)
  template = File.read("#{File.dirname(__FILE__)}/templates/#{file}.erb")
  result = ERB.new(template).result(binding)
end
