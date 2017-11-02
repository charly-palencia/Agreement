module BlueprintAgreement
  class DrakovService
    attr :pid, :port, :hostname, :root_path, :allow_headers
    INVALID_RESPONSE = {
      content_type: 'text/html',
      body: 'Endpoint not found',
      code: '404'
    }

    def initialize(config = BlueprintAgreement.configuration)
      @config = config
      @port = @config.port
      @allow_headers = @config.allow_headers
      @hostname = @config.hostname
      @root_path = @config.server_path
    end

    def start(path)
      @pid = spawn "drakov -f #{root_path}/#{path} -p #{port} #{allow_headers}".strip, options
      @config.active_service = { pid: @pid, path: path }
    end

    def stop
      Process.kill 'TERM', @config.active_service[:pid]
      @config.active_service = nil
    end

    def host
      "#{hostname}:#{port}"
    end

    def installed?
      `which drakov`.length > 0
    end

    def install
      print "installing drakov.."
      pid = Process.spawn "npm install -g drakov"
      Process.wait pid
      print "Drakov installed 🍺  "
    end
    private

    def options
      return {} if ENV["AGREEMENT_LOUD"]

      { out: '/dev/null' }
    end
  end
end
