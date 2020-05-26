# frozen_string_literal: true

module MaintainersHelper
  def maintainer_menu_data branch, maintainer, opened_bugs, all_bugs
    map = {
      information: {
         args: {controller: :maintainers, action: :show, branch: branch.slug, login: maintainer.login},
         popup: 'information about maintainer'
      },
      packages: {
         args: {controller: :srpms, action: :maintained, branch: branch.slug, login: maintainer.login},
         popup: 'packages, which was built by this maintainer',
      },
      gear: {
         args: {controller: :gears, action: :index, branch: branch.slug, login: maintainer.login},
         popup: 'gear repositories, which maintainer is involved in',
      },
      bugs: {
         title: _('Bugs') + ' (%s/%s)' % [opened_bugs.count, all_bugs.count],
         args: {controller: :issues, action: :bugs, branch: branch.slug, login: maintainer.login},
         popup: 'list of bugs and feature requests',
      },
      ftbfs: {
         title: 'FTBFS',
         args: {controller: :issues, action: :ftbfses, branch: branch.slug, login: maintainer.login},
         popup: 'FTBFS list',
      },
      novelties: {
         title: 'Watch',
         args: {controller: :issues, action: :novelties, branch: branch.slug, login: maintainer.login},
         popup: 'watch novelties of the external packages monitoring',
      },
      repocop: {
         args: {controller: :repocop_notes, action: :maintained, branch: branch.slug, login: maintainer.login},
         popup: 'repocop bugreports',
         valid: 'perpetual?'
      },
      tasks: {
         args: {controller: :tasks, action: :index, branch: branch.slug, login: maintainer.login},
         popup: 'build tasks, which maintainer have originated',
      },
    }

    map.map do |(title, data)|
      data[:title] ||= _(title.to_s.capitalize)

      [title, data]
    end.to_h
  end
end
