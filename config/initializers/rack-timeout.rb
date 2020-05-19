# frozen_string_literal: true
require 'rack-timeout'
Rails.application.config.middleware.insert_before Rack::Runtime, Rack::Timeout, service_timeout: 240, wait_timeout: 240, wait_overtime: 240
