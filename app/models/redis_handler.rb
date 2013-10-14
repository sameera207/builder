class RedisHandler
  include Sidekiq::Worker

  def perform(id)
    run_command(id)

    build = Build.find(id)
    build.completed_at = DateTime.now
    build.save 
  end

  def run_command(build_id)
    $stdout.sync = true

    build = Build.find(build_id)

    command = build.project.command.to_s.gsub("?", build.branch_name) 

    IO::popen(command) do |f|
      until f.eof?
        m = Message.new
        m.name = ""
        m.content = f.gets
        publish(m.to_json)
        sleep 0.5
      end
    end
    m = Message.new
    m.name = "status"
    m.content = "completed"
    publish(m.to_json)
  end
  
  def publish(data, queue = 'build.data')
    $redis.publish(queue, data) 
  end

  def subscribe
    $redis.subscribe('build.data') do |on|
      on.message do |channel, msg|
        data = JSON.parse(msg)
        p "#{data}"
      end
    end
  end

end
