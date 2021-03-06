require 'multi_json'

module Leadlight

  class ServiceMiddleware
    def initialize(app, options={})
      @app = app
      @service = options.fetch(:service)
    end

    def call(env)
      env[:leadlight_service] = @service
      env[:request_headers]['Accept'] = default_accept_types
      @app.call(env).on_complete do |env|
        env[:leadlight_representation] = represent(env)
      end
    end

    private

    def default_accept_types
      %w[
        application/json
        text/x-yaml
        application/xml
        application/xhtml+xml
        text/html
        text/plain
      ]
    end

    def represent(env)
      leadlight_request = env[:request].fetch(:leadlight_request)
      leadlight_request.represent(env)
    end
  end

end
