# frozen_string_literal: true

module MaintainersHelper
  def maintainer_menu_data branch, maintainer, opened_bugs, all_bugs
    map = {
      information: {
         popup: _('Information'),
         args: {controller: :maintainers, action: :show, branch: branch.slug, login: maintainer.login},
         popup: _('information about maintainer')
      },
      packages: {
         popup: _('Packages'),
         args: {controller: :srpms, action: :maintained, branch: branch.slug, login: maintainer.login},
         popup: _('packages, which was built by this maintainer'),
      },
      gear: {
         popup: _('Gear'),
         args: {controller: :gears, action: :index, branch: branch.slug, login: maintainer.login},
         popup: _('gear repositories, which maintainer is involved in'),
      },
      bugs: {
         title: _('Bugs') + ' (%s/%s)' % [opened_bugs.count, all_bugs.count],
         args: {controller: :issues, action: :bugs, branch: branch.slug, login: maintainer.login},
         popup: _('list of bugs and feature requests'),
      },
      ftbfs: {
         title: _('FTBFS'),
         args: {controller: :issues, action: :ftbfses, branch: branch.slug, login: maintainer.login},
         popup: _('FTBFS list'),
      },
      novelties: {
         title: _('Watch'),
         args: {controller: :issues, action: :novelties, branch: branch.slug, login: maintainer.login},
         popup: _('watch novelties of the external packages monitoring'),
      },
      repocop: {
         popup: _('Repocop'),
         args: {controller: :repocop_notes, action: :maintained, branch: branch.slug, login: maintainer.login},
         popup: _('repocop bugreports'),
         valid: 'perpetual?'
      },
      tasks: {
         popup: _('Tasks'),
         args: {controller: :tasks, action: :index, branch: branch.slug, login: maintainer.login},
         popup: _('build tasks, which maintainer have originated'),
      },
    }

    map.map do |(title, data)|
      data[:title] ||= _(title.to_s.capitalize)

      [title, data]
    end.to_h
  end
end
