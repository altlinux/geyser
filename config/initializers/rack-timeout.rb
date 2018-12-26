# frozen_string_literal: true
if defined? Rack::Timeout
   Rack::Timeout.service_timeout = 60
end
