# frozen_string_literal: true

class TaskDecorator < Draper::Decorator
  delegate_all

  def exercise_links
    exercises.reduce("") do |res, e|
      url = resource_url_for(e)
      opts = { class: e.kind + ' badge', target: "_blank", rel: "nofollow noopener noreferrer" }
      res + h.link_to(e.pkgname, url, opts)
    end.html_safe
  end

  protected

  def resource_url_for exercise
    case exercise.kind
    when 'repo'
      exercise.resource
    when 'copy'
      /(?<branch_name>[^:]*):(?<pkgname>.*)/ =~ exercise.resource
      h.srpm_url(branch: branch_name.gsub(".", "_"), reponame: pkgname)
    when 'delete', 'srpm'
      h.search_url(query: exercise.pkgname, utf8: "✓")
    end
  end
end
