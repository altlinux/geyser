# frozen_string_literal: true

# Be sure to restart your server when you modify this file.
# TODO: remove this
require 'action_dispatch/middleware/session/dalli_store'
Rails.application.config.session_store :dalli_store, :memcache_server => ['packages.altlinux.org'], :namespace => 'sessions', :key => '_geyser_session'
