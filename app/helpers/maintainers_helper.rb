# frozen_string_literal: true

module MaintainersHelper
  def maintainer_menu_data branch, maintainer, opened_bugs, all_bugs
    map = {
      information: {
         path: 'maintainer_path',
         args: [branch, maintainer],
         popup: 'information about maintainer'
      },
      packages: {
         path: 'srpms_maintainer_path',
         args: [branch, maintainer],
         popup: 'packages, which was built by this maintainer',
      },
      gear: {
         path: 'gear_maintainer_path',
         args: [branch, maintainer],
         popup: 'gear repositories which maintainer is involved in',
      },
      bugs: {
         title: _('Bugs') + ' (%s/%s)' % [opened_bugs.count, all_bugs.count],
         path: 'bugs_maintainer_path',
         args: [branch, maintainer],
         popup: 'list of bugs and feature requests',
      },
      ftbfs: {
         title: 'FTBFS',
         path: 'ftbfs_maintainer_path',
         args: [branch, maintainer],
         popup: 'FTBFS',
      },
      watches: {
         title: 'Watches',
         path: 'watches_maintainer_path',
         args: [branch, maintainer],
         popup: 'watches',
      },
      repocop: {
         path: 'repocop_maintainer_path',
         args: [branch, maintainer],
         popup: 'repocop bugreports',
         valid: 'perpetual?'
      }
    }

    map.map do |(title, data)|
      data[:title] ||= _(title.to_s.capitalize)

      [title, data]
    end.to_h
  end
end
