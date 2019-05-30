# frozen_string_literal: true

if Rails.env.production?
  Rails.application.config.middleware.use ExceptionNotification::Rack,
                                          email: {
                                            email_prefix: '[ERROR] ',
                                            sender_address: %('Sisyphus 2.0 Error' <geyser-noreply@altlinux.org>),
                                            exception_recipients: ['3aHyga@gmail.com']
                                          }
end
