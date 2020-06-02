# frozen_string_literal: true

module SrpmsHelper
  def colorize_specfile(text)
    text.force_encoding('UTF-8')
    text = text.gsub('@altlinux', ' at altlinux')
    text = text.gsub(/#/,"\uFEFF")

    # ${$text}=~ s/&/&amp;/g;
    # ${$text}=~ s/>/&gt;/g;
    # ${$text}=~ s/</&lt;/g;
    # ${$text}=~ s/\"/&quot;/g;

    # ${$text}=~ s/\@/ at /g;

    # ${$text}=~ s/(Url\:\s+)(((http|ftp)\:\/\/[^\s\[\]]{1,100})([^\s\]\[]*))/"$1".&linkme($2,$3,$5)/gie;
    # TODO: add link to Url:

    # ${$text}=~ s/^(\w+\:)/<b>$1<\/b>/g;

    text = h(text.gsub(/\t/, ' ' * 8))
    text = text.gsub(/^(\w+\:)/) { |s| s = "<b>#{ s }</b>" }

    # ${$text}=~ s/^(\s*\#.*)/<b class='comment'>$1<\/b>/g;
    # text = text.gsub(/^(\s*\#.*)/) { |s| s = "<b class='comment'>#{s}</b>" }

    # ${$text}=~ s/\n([\w\(\)\-\.]+\:)/\n<b>$1<\/b>/g;
    text = text.gsub(/\n([\w\(\)\-\.]+\:)/) { |s| s = "<b>#{ s }</b>" }

    # ${$text}=~ s/\n(\s*\#.*)/\n<b class='comment'>$1<\/b>/g;

    text = text.gsub(/(\s*\uFEFF.*)/) { |s| s = "<b class='comment'>#{ s }</b>" }
    text = text.gsub(/\uFEFF/, '#')

    # ${$text}=~ s/\n\%(description|prep|build|install|preun|pre|postun|post|triggerpostun|trigger|files|changelog|package)([\n|\s])/\n<b class='reserved'>\%$1<\/b>$2/g;
    text = text.gsub(/^%(description|prep|build|check|install|preun|pre|postun|post|triggerpostun|trigger|files|changelog|package)/) { |s| s = "<b class='reserved'>#{ s }</b>" }

    # ${$text}=~ s/\n/<br \/>/g;
    text = text.gsub(/\n/, '<br>')

    # ${$text}=~ s/\r//g;
    text = text.gsub(/\r/, '')

    text.html_safe
  end

  def menu_data branch, srpm, opened_bugs, all_bugs, evrb
    map = {
      main: {
         popup: _('Main'),
         args: {controller: :srpms, action: :show, branch: branch.slug, reponame: srpm.name},
         popup: _('information about SRPM')
      },
      changelog: {
         popup: _('Changelog'),
         args: {controller: :changelogs, action: :index, branch: branch.slug, reponame: srpm.name},
         popup: _('full changelog'),
      },
      spec: {
         popup: _('Spec'),
         args: {controller: :specfiles, action: :show, branch: branch.slug, reponame: srpm.name},
         popup: _('spec'),
      },
      patches: {
         popup: _('Patches'),
         args: {controller: :patches, action: :index, branch: branch.slug, reponame: srpm.name},
         popup: _('patches'),
      },
      sources: {
         popup: _('Sources'),
         args: {controller: :sources, action: :index, branch: branch.slug, reponame: srpm.name},
         popup: _('sources'),
      },
      download: {
         popup: _('Download'),
         args: {controller: :rpms, action: :index, branch: branch.slug, reponame: srpm.name},
         popup: _('download latest version'),
      },
      bugs: {
         title: _('Bugs') + ' (%s/%s)' % [opened_bugs.count, all_bugs.count],
         args: {controller: :issues, action: :index, branch: branch.slug, reponame: srpm.name, b: !branch.perpetual? && branch.slug},
         popup: _('list of bugs and feature requests'),
      },
      repocop: {
         popup: _('Repocop'),
         args: {controller: :repocop_notes, action: :index, branch: branch.slug, reponame: srpm.name},
         popup: _('repocop bugreports'),
         valid: 'perpetual?'
      },
      repos: {
         title: _('Git Repos'),
         args: {controller: :gears, action: :repos, branch: branch.slug, reponame: srpm.name},
         popup: _('git repos associated with the package'),
      },
      tasks: {
         title: _('Tasks'),
         args: {controller: :tasks, action: :pkg_index, branch: branch.slug, reponame: srpm.name},
         popup: _('build tasks associated with the package'),
      }
    }

    map.map do |(title, data)|
      data[:args][:evrb] = evrb if evrb
      data[:title] ||= _(title.to_s.capitalize)
      data[:args] = data[:args].select { |k, v| v }

      [title, data]
    end.to_h
  end

  def self_url_for name
    url_for(sort: name,
            order: (params[:sort].to_s =~ /^(#{name}|)$/ && params[:order] != 'desc') && 'desc' || 'asc')
  end
end
