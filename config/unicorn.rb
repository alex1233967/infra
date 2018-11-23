@dir = ENV['PWD']

worker_processes 1
working_directory @dir

preload_app true

timeout 30

listen "#{@dir}/tmp/sockets/unicorn.sock", :backlog => 32

pid "#{@dir}/tmp/pids/unicorn.pid"

stderr_path "#{@dir}/log/a.unicorn.log"
stdout_path "#{@dir}/log/e.unicorn.log"
