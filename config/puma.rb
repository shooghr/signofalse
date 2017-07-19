# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum, this matches the default thread size of Active Record.
DEPLOY_ROOT = '/var/www/signo'
app_dir = File.expand_path('../..', __FILE__)
shared_dir = "#{ DEPLOY_ROOT }/shared"


threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }.to_i
threads threads_count, threads_count
bind "unix://#{shared_dir}/sockets/puma.sock"
environment ENV.fetch('RAILS_ENV') { 'production' }
workers ENV.fetch('WEB_CONCURRENCY') { 2 }
pidfile "#{shared_dir}/pids/puma.pid"
daemonize true


stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log"

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
