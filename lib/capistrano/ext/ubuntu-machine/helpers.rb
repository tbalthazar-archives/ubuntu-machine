require 'erb'

# render a template
def render(file, binding)
  template = File.read("#{File.dirname(__FILE__)}/templates/#{file}.erb")
  result = ERB.new(template).result(binding)
end

# allows to sudo a command which require the user input via the prompt
def sudo_and_watch_prompt(cmd, regex_to_watch)
  sudo cmd, :pty => true do |ch, stream, data|
    watch_prompt(ch, stream, data, regex_to_watch)
  end
end

# allows to run a command which require the user input via the prompt
def run_and_watch_prompt(cmd, regex_to_watch)
  run cmd, :pty => true do |ch, stream, data|
    watch_prompt(ch, stream, data, regex_to_watch)
  end
end

# utility method called by sudo_and_watch_prompt and run_and_watch_prompt
def watch_prompt(ch, stream, data, regex_to_watch)

  # the regex can be an array or a single regex -> we force it to always be an array with [*xx]
  if [*regex_to_watch].find { |regex| data =~ regex}
    # prompt, and then send the response to the remote process
    ch.send_data(Capistrano::CLI.password_prompt(data) + "\n")
  else
    # use the default handler for all other text
    Capistrano::Configuration.default_io_proc.call(ch, stream, data)
  end
end


