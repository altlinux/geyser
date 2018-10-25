# frozen_string_literal: true

class BugDecorator < Draper::Decorator
  delegate_all

  def bugzilla_url
    "https://bugzilla.altlinux.org/#{ no }"
  end

  def link_to_bugzilla
    h.link_to(no, bugzilla_url, class: 'news')
  end
end
