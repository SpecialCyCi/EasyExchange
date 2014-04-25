# encoding: utf-8
namespace :dev do
  desc "Rebuild system"
  task :build => ["tmp:clear", "log:clear", "db:drop", "db:create", "db:migrate", "db:seed", "db:test:prepare"]
  task :reset => ["db:drop", "db:create", "db:migrate", "db:seed","db:test:prepare"]

  desc "Run application relative environment"

  task :run_env, [:redis_conf_path, :sidekiq_log_path] do |t,args|
    args.with_defaults(:redis_conf_path => '/usr/local/etc/redis.conf', :sidekiq_log_path => "/tmp/sidekiq.log")
    puts "Run redis with config file: #{args[:redis_conf_path]}"
    status = system "redis-server #{args[:redis_conf_path]} &"
    puts "Run redis status: #{status}"
    puts "Run sidekiq with log file: #{args[:sidekiq_log_path]}"
    status = system "bundle exec sidekiq -d -l #{args[:sidekiq_log_path]}"
    puts "Run sidekiq status: #{status}"
    status = system "mongod &"
    puts "Run mongod status: #{status}"
    status = system "rake sunspot:solr:start"
    puts "Run sunspot status: #{status}"
    status = system "rake sunspot:reindex"
    puts "Run sunspot reindex status: #{status}"
    puts "[Notice!!!]: This task has not run mysql sever, you need to run it yourself."
  end

  task :stop_env do
    redis_pid = %x(ps aux | grep redis | grep -v grep | awk '{print $2}')
    status = system("kill -9 #{redis_pid} >/dev/null 2>&1")
    puts "Stop redis status: #{status}"
    sidekiq_pid = %x(ps aux | grep sidekiq | grep -v grep | awk '{print $2}')
    status = system("kill -9 #{sidekiq_pid} >/dev/null 2>&1")
    puts "Stop sidekiq status: #{status}"
    mongod_pid = %x(ps aux | grep mongod | grep -v grep | awk '{print $2}')
    status = system("kill -9 #{mongod_pid} >/dev/null 2>&1")
    puts "Stop mongod status: #{status}"
    solr_pid = %x(ps aux | grep solr | grep -v grep | awk '{print $2}')
    status = system("kill -9 #{solr_pid} >/dev/null 2>&1")
    puts "Stop solr status: #{status}"
  end

end
