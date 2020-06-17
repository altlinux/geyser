# frozen_string_literal: true

xml.instruct!
xml.rss "version" => "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "Fresh packages in #{ @branch.name }"
    xml.link url_for(only_path: false, controller: 'srpms', action: 'index')
    xml.tag! 'atom:link', rel: 'self',
                          type: 'application/rss+xml',
                          href: url_for(only_path: false,
                                        controller: 'rss',
                                        action: 'index',
                                        branch: @branch.slug)
    xml.description "Fresh packages in #{ @branch.name }"
    xml.ttl 60
    for srpm in @srpms do
      xml.item do
        xml.title "#{ srpm.name }-#{ srpm.evr }"
        xml.link url_for(only_path: false, controller: 'srpms', action: 'show', reponame: srpm.name, branch: @branch.slug)
        xml.description simple_format("#{srpm.last_changelog_text}")
        xml.guid "#{ srpm.name }-#{ srpm.evr }", isPermaLink: false
      end
    end
  end
end
