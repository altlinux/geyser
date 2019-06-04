# frozen_string_literal: true
if defined? Rack::Timeout
   Rails.application.config.middleware.insert_before Rack::Runtime, Rack::Timeout, service_timeout: 240, wait_timeout: 240, wait_overtime: 240
end
