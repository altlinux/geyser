# frozen_string_literal: true

FastGettext.add_text_domain 'app', path: 'locale', type: :po
FastGettext.default_text_domain = 'app'
FastGettext.default_available_locales = %w(en ru)
