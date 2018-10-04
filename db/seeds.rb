# frozen_string_literal: true

if Branch.all.blank?
# add Sisyphus branch
branch = Branch.new
branch.vendor = 'ALT Linux'
branch.name = 'Sisyphus'
branch.order_id = 0
branch.path = '/Sisyphus'
# branch.srpm_path = ['/ALT/Sisyphus/files/SRPMS']
branch.save!

# add SisyphusARM branch
branch = Branch.new
branch.vendor = 'ALT Linux'
branch.name = 'SisyphusARM'
branch.order_id = 1
branch.path = '/Sisyphus'
# branch.srpm_path = []
branch.save!

# add Platform8 branch
branch = Branch.new
branch.vendor = 'ALT Linux'
branch.name = 'p8'
branch.order_id = 2
branch.path = '/p8/branch'
branch.save!

# add Platform7 branch
branch = Branch.new
branch.vendor = 'ALT Linux'
branch.name = 'p7'
branch.order_id = 3
branch.path = '/p7/branch'
branch.save!

# add t7 branch
branch = Branch.new
branch.vendor = 'ALT Linux'
branch.name = 't7'
branch.order_id = 4
branch.path = '/t7/branch'
branch.save!

# add Platform6 branch
branch = Branch.new
branch.vendor = 'ALT Linux'
branch.name = 'Platform6'
branch.order_id = 5
branch.path = '/p6/branch'
branch.save!

# add t6 branch
branch = Branch.new
branch.vendor = 'ALT Linux'
branch.name = 't6'
branch.order_id = 6
branch.path = '/t6/branch'
branch.save!

# add Platform5 branch
branch = Branch.new
branch.vendor = 'ALT Linux'
branch.name = 'Platform5'
branch.order_id = 7
branch.path = '/p5/branch'
branch.save!

# add 5.1 branch
branch = Branch.new
branch.vendor = 'ALT Linux'
branch.name = '5.1'
branch.order_id = 8
branch.path = '/5.1/branch'
branch.save!

# add 5.0 branch
branch = Branch.new
branch.vendor = 'ALT Linux'
branch.name = '5.0'
branch.order_id = 9
branch.path = '/5.0/branch'
branch.save!

# add 4.1 branch
branch = Branch.new
branch.vendor = 'ALT Linux'
branch.name = '4.1'
branch.order_id = 10
branch.path = '/4.1/branch'
branch.save!

# add 4.0 branch
branch = Branch.new
branch.vendor = 'ALT Linux'
branch.name = '4.0'
branch.order_id = 11
branch.path = '/4.0/branch'
branch.save!

# add Fedora Rawhide
# branch = Branch.new
# branch.fullname = 'Rawhide'
# branch.urlname = 'Rawhide'
# branch.srpms_path = "/path/*.src.rpm"
# branch.altlinux = false
# branch.save!

# Mirrors for Sisyphus
branch = Branch.find_by(name: 'Sisyphus', vendor: 'ALT Linux')
Mirror.create!(
  branch_id: branch.id,
  order_id: 0,
  name: 'http://ftp.altlinux.org',
  country: 'ru',
  uri: 'http://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 1,
  name: 'ftp://ftp.altlinux.org',
  country: 'ru',
  uri: 'ftp://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 2,
  name: 'rsync://ftp.altlinux.org',
  country: 'ru',
  uri: 'rsync://ftp.altlinux.org/ALTLinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 3,
  name: 'http://mirror.yandex.ru/',
  country: 'ru',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 4,
  name: 'ftp://mirror.yandex.ru/',
  country: 'ru',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 5,
  name: 'rsync://mirror.yandex.ru/',
  country: 'ru',
  uri: 'rsync://mirror.yandex.ru/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 6,
  name: 'http://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 7,
  name: 'ftp://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 8,
  name: 'rsync://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 9,
  name: 'http://ftp.heanet.ie/',
  country: 'ie',
  uri: 'http://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 10,
  name: 'ftp://ftp.heanet.ie/',
  country: 'ie',
  uri: 'ftp://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 11,
  name: 'rsync://ftp.heanet.ie/',
  country: 'ie',
  uri: 'rsync://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'rsync'
)

# Mirrors for SisyphusARM
# branch = Branch.find_by(name: 'SisyphusARM', vendor: 'ALT Linux')
# Mirror.create!(
#   branch_id: branch.id,
#   order_id: 0,
#   name: 'ftp://ftp.altlinux.org',
#   country: 'ru',
#   uri: 'ftp://ftp.altlinux.org/pub/distributions/ALTLinux',
#   protocol: 'ftp'
# )
# Mirror.create!(
#   branch_id: branch.id,
#   order_id: 1,
#   name: 'http://ftp.altlinux.org',
#   country: 'ru',
#   uri: 'http://ftp.altlinux.org/pub/distributions/ALTLinux',
#   protocol: 'http'
# )
# Mirror.create!(
#   branch_id: branch.id,
#   order_id: 2,
#   name: 'rsync://ftp.altlinux.org',
#   country: 'ru',
#   uri: 'rsync://ftp.altlinux.org/ALTLinux',
#   protocol: 'rsync'
# )

# Mirrors for p8
branch = Branch.find_by(name: 'p8', vendor: 'ALT Linux')
Mirror.create!(
  branch_id: branch.id,
  order_id: 0,
  name: 'http://ftp.altlinux.org',
  country: 'ru',
  uri: 'http://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 1,
  name: 'ftp://ftp.altlinux.org',
  country: 'ru',
  uri: 'ftp://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 2,
  name: 'rsync://ftp.altlinux.org',
  country: 'ru',
  uri: 'rsync://ftp.altlinux.org/ALTLinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 3,
  name: 'http://mirror.yandex.ru/',
  country: 'ru',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 4,
  name: 'ftp://mirror.yandex.ru/',
  country: 'ru',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 5,
  name: 'rsync://mirror.yandex.ru/',
  country: 'ru',
  uri: 'rsync://mirror.yandex.ru/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 6,
  name: 'http://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 7,
  name: 'ftp://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 8,
  name: 'rsync://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 9,
  name: 'http://ftp.heanet.ie/',
  country: 'ie',
  uri: 'http://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 10,
  name: 'ftp://ftp.heanet.ie/',
  country: 'ie',
  uri: 'ftp://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 11,
  name: 'rsync://ftp.heanet.ie/',
  country: 'ie',
  uri: 'rsync://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'rsync'
)

# Mirrors for p7
branch = Branch.find_by(name: 'p7', vendor: 'ALT Linux')
Mirror.create!(
  branch_id: branch.id,
  order_id: 0,
  name: 'http://ftp.altlinux.org',
  country: 'ru',
  uri: 'http://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 1,
  name: 'ftp://ftp.altlinux.org',
  country: 'ru',
  uri: 'ftp://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 2,
  name: 'rsync://ftp.altlinux.org',
  country: 'ru',
  uri: 'rsync://ftp.altlinux.org/ALTLinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 3,
  name: 'http://mirror.yandex.ru/',
  country: 'ru',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 4,
  name: 'ftp://mirror.yandex.ru/',
  country: 'ru',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 5,
  name: 'rsync://mirror.yandex.ru/',
  country: 'ru',
  uri: 'rsync://mirror.yandex.ru/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 6,
  name: 'http://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 7,
  name: 'ftp://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 8,
  name: 'rsync://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 9,
  name: 'http://ftp.heanet.ie/',
  country: 'ie',
  uri: 'http://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 10,
  name: 'ftp://ftp.heanet.ie/',
  country: 'ie',
  uri: 'ftp://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 11,
  name: 'rsync://ftp.heanet.ie/',
  country: 'ie',
  uri: 'rsync://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'rsync'
)

# Mirrors for t7
branch = Branch.find_by(name: 't7', vendor: 'ALT Linux')
Mirror.create!(
  branch_id: branch.id,
  order_id: 0,
  name: 'http://ftp.altlinux.org',
  country: 'ru',
  uri: 'http://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 1,
  name: 'ftp://ftp.altlinux.org',
  country: 'ru',
  uri: 'ftp://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 2,
  name: 'rsync://ftp.altlinux.org',
  country: 'ru',
  uri: 'rsync://ftp.altlinux.org/ALTLinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 3,
  name: 'http://mirror.yandex.ru/',
  country: 'ru',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 4,
  name: 'ftp://mirror.yandex.ru/',
  country: 'ru',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 5,
  name: 'rsync://mirror.yandex.ru/',
  country: 'ru',
  uri: 'rsync://mirror.yandex.ru/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 6,
  name: 'http://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 7,
  name: 'ftp://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 8,
  name: 'rsync://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 9,
  name: 'http://ftp.heanet.ie/',
  country: 'ie',
  uri: 'http://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 10,
  name: 'ftp://ftp.heanet.ie/',
  country: 'ie',
  uri: 'ftp://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 11,
  name: 'rsync://ftp.heanet.ie/',
  country: 'ie',
  uri: 'rsync://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'rsync'
)

# Mirrors for Platform6
branch = Branch.find_by(name: 'Platform6', vendor: 'ALT Linux')
Mirror.create!(
  branch_id: branch.id,
  order_id: 0,
  name: 'http://ftp.altlinux.org',
  country: 'ru',
  uri: 'http://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 1,
  name: 'ftp://ftp.altlinux.org',
  country: 'ru',
  uri: 'ftp://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 2,
  name: 'rsync://ftp.altlinux.org',
  country: 'ru',
  uri: 'rsync://ftp.altlinux.org/ALTLinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 3,
  name: 'http://mirror.yandex.ru/',
  country: 'ru',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 4,
  name: 'ftp://mirror.yandex.ru/',
  country: 'ru',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 5,
  name: 'rsync://mirror.yandex.ru/',
  country: 'ru',
  uri: 'rsync://mirror.yandex.ru/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 6,
  name: 'http://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 7,
  name: 'ftp://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 8,
  name: 'rsync://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 9,
  name: 'http://ftp.heanet.ie/',
  country: 'ie',
  uri: 'http://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 10,
  name: 'ftp://ftp.heanet.ie/',
  country: 'ie',
  uri: 'ftp://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 11,
  name: 'rsync://ftp.heanet.ie/',
  country: 'ie',
  uri: 'rsync://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'rsync'
)

# Mirrors for t6
branch = Branch.find_by(name: 't6', vendor: 'ALT Linux')
Mirror.create!(
  branch_id: branch.id,
  order_id: 0,
  name: 'http://ftp.altlinux.org',
  country: 'ru',
  uri: 'http://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 1,
  name: 'ftp://ftp.altlinux.org',
  country: 'ru',
  uri: 'ftp://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 2,
  name: 'rsync://ftp.altlinux.org',
  country: 'ru',
  uri: 'rsync://ftp.altlinux.org/ALTLinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 3,
  name: 'http://mirror.yandex.ru/',
  country: 'ru',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 4,
  name: 'ftp://mirror.yandex.ru/',
  country: 'ru',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 5,
  name: 'rsync://mirror.yandex.ru/',
  country: 'ru',
  uri: 'rsync://mirror.yandex.ru/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 6,
  name: 'http://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 7,
  name: 'ftp://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 8,
  name: 'rsync://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 9,
  name: 'http://ftp.heanet.ie/',
  country: 'ie',
  uri: 'http://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 10,
  name: 'ftp://ftp.heanet.ie/',
  country: 'ie',
  uri: 'ftp://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 11,
  name: 'rsync://ftp.heanet.ie/',
  country: 'ie',
  uri: 'rsync://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'rsync'
)

# Mirrors for Platform5
branch = Branch.find_by(name: 'Platform5', vendor: 'ALT Linux')
Mirror.create!(
  branch_id: branch.id,
  order_id: 0,
  name: 'http://ftp.altlinux.org',
  country: 'ru',
  uri: 'http://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 1,
  name: 'ftp://ftp.altlinux.org',
  country: 'ru',
  uri: 'ftp://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 2,
  name: 'rsync://ftp.altlinux.org',
  country: 'ru',
  uri: 'rsync://ftp.altlinux.org/ALTLinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 3,
  name: 'http://mirror.yandex.ru/',
  country: 'ru',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 4,
  name: 'ftp://mirror.yandex.ru/',
  country: 'ru',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 5,
  name: 'rsync://mirror.yandex.ru/',
  country: 'ru',
  uri: 'rsync://mirror.yandex.ru/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 6,
  name: 'http://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 7,
  name: 'ftp://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 8,
  name: 'rsync://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 9,
  name: 'http://ftp.heanet.ie/',
  country: 'ie',
  uri: 'http://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 10,
  name: 'ftp://ftp.heanet.ie/',
  country: 'ie',
  uri: 'ftp://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 11,
  name: 'rsync://ftp.heanet.ie/',
  country: 'ie',
  uri: 'rsync://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'rsync'
)

# Mirrors for 5.1
branch = Branch.find_by(name: '5.1', vendor: 'ALT Linux')
Mirror.create!(
  branch_id: branch.id,
  order_id: 0,
  name: 'http://ftp.altlinux.org',
  country: 'ru',
  uri: 'http://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 1,
  name: 'ftp://ftp.altlinux.org',
  country: 'ru',
  uri: 'ftp://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 2,
  name: 'rsync://ftp.altlinux.org',
  country: 'ru',
  uri: 'rsync://ftp.altlinux.org/ALTLinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 3,
  name: 'http://mirror.yandex.ru/',
  country: 'ru',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 4,
  name: 'ftp://mirror.yandex.ru/',
  country: 'ru',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 5,
  name: 'rsync://mirror.yandex.ru/',
  country: 'ru',
  uri: 'rsync://mirror.yandex.ru/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 6,
  name: 'http://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 7,
  name: 'ftp://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 8,
  name: 'rsync://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 9,
  name: 'http://ftp.heanet.ie/',
  country: 'ie',
  uri: 'http://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 10,
  name: 'ftp://ftp.heanet.ie/',
  country: 'ie',
  uri: 'ftp://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 11,
  name: 'rsync://ftp.heanet.ie/',
  country: 'ie',
  uri: 'rsync://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'rsync'
)

# Mirrors for 5.0
branch = Branch.find_by(name: '5.0', vendor: 'ALT Linux')
Mirror.create!(
  branch_id: branch.id,
  order_id: 0,
  name: 'http://ftp.altlinux.org',
  country: 'ru',
  uri: 'http://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 1,
  name: 'ftp://ftp.altlinux.org',
  country: 'ru',
  uri: 'ftp://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 2,
  name: 'rsync://ftp.altlinux.org',
  country: 'ru',
  uri: 'rsync://ftp.altlinux.org/ALTLinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 3,
  name: 'http://mirror.yandex.ru/',
  country: 'ru',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 4,
  name: 'ftp://mirror.yandex.ru/',
  country: 'ru',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 5,
  name: 'rsync://mirror.yandex.ru/',
  country: 'ru',
  uri: 'rsync://mirror.yandex.ru/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 6,
  name: 'http://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 7,
  name: 'ftp://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 8,
  name: 'rsync://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 9,
  name: 'http://ftp.heanet.ie/',
  country: 'ie',
  uri: 'http://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 10,
  name: 'ftp://ftp.heanet.ie/',
  country: 'ie',
  uri: 'ftp://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 11,
  name: 'rsync://ftp.heanet.ie/',
  country: 'ie',
  uri: 'rsync://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'rsync'
)

# Mirrors for 4.1
branch = Branch.find_by(name: '4.1', vendor: 'ALT Linux')
Mirror.create!(
  branch_id: branch.id,
  order_id: 0,
  name: 'http://ftp.altlinux.org',
  country: 'ru',
  uri: 'http://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 1,
  name: 'ftp://ftp.altlinux.org',
  country: 'ru',
  uri: 'ftp://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 2,
  name: 'rsync://ftp.altlinux.org',
  country: 'ru',
  uri: 'rsync://ftp.altlinux.org/ALTLinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 3,
  name: 'http://mirror.yandex.ru/',
  country: 'ru',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 4,
  name: 'ftp://mirror.yandex.ru/',
  country: 'ru',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 5,
  name: 'rsync://mirror.yandex.ru/',
  country: 'ru',
  uri: 'rsync://mirror.yandex.ru/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 6,
  name: 'http://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 7,
  name: 'ftp://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 8,
  name: 'rsync://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 9,
  name: 'http://ftp.heanet.ie/',
  country: 'ie',
  uri: 'http://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 10,
  name: 'ftp://ftp.heanet.ie/',
  country: 'ie',
  uri: 'ftp://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 11,
  name: 'rsync://ftp.heanet.ie/',
  country: 'ie',
  uri: 'rsync://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'rsync'
)

# Mirrors for 4.0
branch = Branch.find_by(name: '4.0', vendor: 'ALT Linux')
Mirror.create!(
  branch_id: branch.id,
  order_id: 0,
  name: 'http://ftp.altlinux.org',
  country: 'ru',
  uri: 'http://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 1,
  name: 'ftp://ftp.altlinux.org',
  country: 'ru',
  uri: 'ftp://ftp.altlinux.org/pub/distributions/ALTLinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 2,
  name: 'rsync://ftp.altlinux.org',
  country: 'ru',
  uri: 'rsync://ftp.altlinux.org/ALTLinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 3,
  name: 'http://mirror.yandex.ru/',
  country: 'ru',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 4,
  name: 'ftp://mirror.yandex.ru/',
  country: 'ru',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 5,
  name: 'rsync://mirror.yandex.ru/',
  country: 'ru',
  uri: 'rsync://mirror.yandex.ru/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 6,
  name: 'http://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'http://mirror.yandex.ru/altlinux',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 7,
  name: 'ftp://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'ftp://mirror.yandex.ru/altlinux',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 8,
  name: 'rsync://distrib-coffee.ipsl.jussieu.fr/',
  country: 'fr',
  uri: 'rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/altlinux',
  protocol: 'rsync'
)

Mirror.create!(
  branch_id: branch.id,
  order_id: 9,
  name: 'http://ftp.heanet.ie/',
  country: 'ie',
  uri: 'http://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'http'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 10,
  name: 'ftp://ftp.heanet.ie/',
  country: 'ie',
  uri: 'ftp://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'ftp'
)
Mirror.create!(
  branch_id: branch.id,
  order_id: 11,
  name: 'rsync://ftp.heanet.ie/',
  country: 'ie',
  uri: 'rsync://ftp.heanet.ie/mirrors/ftp.altlinux.org',
  protocol: 'rsync'
)

# Mirror.create(:branch_id => branch.id, :order_id => 1, :country => 'ru',
#               :ftp => 'ftp://ftp.chg.ru/pub/Linux/ALTLinux',
#               :rsync => 'rsync://ftp.chg.ru/ALTLinux')
#
# Mirror.create(:branch_id => branch.id, :order_id => 2, :country => 'us',
#               :ftp => 'ftp://ibiblio.org/pub/linux/distributions/altlinux',
#               :http => 'http://distro.ibiblio.org/pub/linux/distributions/altlinux',
#               :rsync => 'rsync://distro.ibiblio.org/distros/altlinux')
#
# Mirror.create(:branch_id => branch.id, :order_id => 4, :country => 'ru',
#               :ftp => 'ftp://mirror.yandex.ru/altlinux',
#               :http => 'http://mirror.yandex.ru/altlinux',
#               :rsync => 'rsync://mirror.yandex.ru/altlinux')

# packager list
Maintainer::Team.create!(
  name: 'Nobody',
  email: 'noboby@altlinux.org',
  login: '@nobody'
)
Maintainer::Team.create!(
  name: 'Eve R. Ybody',
  email: 'everybody@altlinux.org',
  login: '@everybody'
)

Maintainer.create!(
  name: 'Igor Zubkov',
  email: 'icesik@altlinux.org',
  login: 'icesik'
)
Maintainer.create!(
  name: 'Alexey Tourbin',
  email: 'at@altlinux.org',
  login: 'at'
)
Maintainer.create!(
  name: 'Alexey I. Froloff',
  email: 'raorn@altlinux.org',
  login: 'raorn'
)
Maintainer.create!(
  name: 'Eugeny A. Rostovtsev',
  email: 'real@altlinux.org',
  login: 'real'
)
Maintainer.create!(
  name: 'Alexey Rusakov',
  email: 'ktirf@altlinux.org',
  login: 'ktirf'
)
Maintainer.create!(
  name: 'Alex Gorbachenko',
  email: 'algor@altlinux.org',
  login: 'algor'
)
Maintainer.create!(
  name: 'Andriy Stepanov',
  email: 'stanv@altlinux.org',
  login: 'stanv'
)
Maintainer.create!(
  name: 'Anton Farygin',
  email: 'rider@altlinux.org',
  login: 'rider'
)
Maintainer.create!(
  name: 'Igor Muratov',
  email: 'migor@altlinux.org',
  login: 'migor'
)
Maintainer.create!(
  name: 'Mihail A. Pluzhnikov',
  email: 'amike@altlinux.org',
  login: 'amike'
)
Maintainer.create!(
  name: 'Pavel V. Solntsev',
  email: 'p_solntsev@altlinux.org',
  login: 'p_solntsev'
)
Maintainer.create!(
  name: 'Serge Ryabchun',
  email: 'sr@altlinux.org',
  login: 'sr'
)
Maintainer.create!(
  name: 'Yurkovsky Andrey',
  email: 'anyr@altlinux.org',
  login: 'anyr'
)
Maintainer.create!(
  name: 'Mikerin Sergey',
  email: 'mikcor@altlinux.org',
  login: 'mikcor'
)
Maintainer.create!(
  name: 'Alexey Lokhin',
  email: 'warframe@altlinux.org',
  login: 'warframe'
)
Maintainer.create!(
  name: 'Alexey Shabalin',
  email: 'shaba@altlinux.org',
  login: 'shaba'
)
Maintainer.create!(
  name: 'Valery Pipin',
  email: 'vvpi@altlinux.org',
  login: 'vvpi'
)
Maintainer.create!(
  name: 'Pavel Boldin',
  email: 'bp@altlinux.org',
  login: 'bp'
)
Maintainer.create!(
  name: 'Ruslan Hihin',
  email: 'ruslandh@altlinux.org',
  login: 'ruslandh'
)
Maintainer.create!(
  name: 'Sergey Lebedev',
  email: 'barabashka@altlinux.org',
  login: 'barabashka'
)
Maintainer.create!(
  name: 'Konstantin Pavlov',
  email: 'thresh@altlinux.org',
  login: 'thresh'
)
Maintainer.create!(
  name: 'Alexey Morozov',
  email: 'morozov@altlinux.org',
  login: 'morozov'
)
Maintainer.create!(
  name: 'Dmitry V. Levin',
  email: 'ldv@altlinux.org',
  login: 'ldv'
)
Maintainer.create!(
  name: 'Igor Androsov',
  email: 'blake@altlinux.org',
  login: 'blake'
)
Maintainer.create!(
  name: 'Aleksandr Blokhin',
  email: 'sass@altlinux.org',
  login: 'sass'
)
Maintainer.create!(
  name: 'Alexander Plikus',
  email: 'plik@altlinux.org',
  login: 'plik'
)
Maintainer.create!(
  name: 'Vladimir Zhukov',
  email: 'bertis@altlinux.org',
  login: 'bertis'
)
Maintainer.create!(
  name: 'Yura Zotov',
  email: 'yz@altlinux.org',
  login: 'yz'
)
Maintainer.create!(
  name: 'Ilya Kuznetsov',
  email: 'worklez@altlinux.org',
  login: 'worklez'
)
Maintainer.create!(
  name: 'Alex Yustasov',
  email: 'yust@altlinux.org',
  login: 'yust'
)
Maintainer.create!(
  name: 'Konstantin Volckov',
  email: 'goldhead@altlinux.org',
  login: 'goldhead'
)
Maintainer.create!(
  name: 'Andrey Orlov',
  email: 'cray@altlinux.org',
  login: 'cray'
)
Maintainer.create!(
  name: 'Alexander V. Denisov',
  email: 'rupor@altlinux.org',
  login: 'rupor'
)
Maintainer.create!(
  name: 'Peter Novodvorsky',
  email: 'nidd@altlinux.org',
  login: 'nidd'
)
Maintainer.create!(
  name: 'George Kirik',
  email: 'kga@altlinux.org',
  login: 'kga'
)
Maintainer.create!(
  name: 'Eugine V. Kosenko',
  email: 'maverik@altlinux.org',
  login: 'maverik'
)
Maintainer.create!(
  name: 'Konstantin A. Lepikhov',
  email: 'lakostis@altlinux.org',
  login: 'lakostis'
)
Maintainer.create!(
  name: 'George V. Kouryachy',
  email: 'george@altlinux.org',
  login: 'george'
)
Maintainer.create!(
  name: 'Aitov Timur',
  email: 'timonbl4@altlinux.org',
  login: 'timonbl4'
)
Maintainer.create!(
  name: 'Anton Chernyshov',
  email: 'ach@altlinux.org',
  login: 'ach'
)
Maintainer.create!(
  name: 'Denis Baranov',
  email: 'baraka@altlinux.org',
  login: 'baraka'
)
Maintainer.create!(
  name: 'Andrey Lykov',
  email: 'droid@altlinux.org',
  login: 'droid'
)
Maintainer.create!(
  name: 'Grigory Fateyev',
  email: 'greg@altlinux.org',
  login: 'greg'
)
Maintainer.create!(
  name: 'Anton Yanchenko',
  email: 'lizzard@altlinux.org',
  login: 'lizzard'
)
Maintainer.create!(
  name: 'Konstantin Uvarin',
  email: 'lodin@altlinux.org',
  login: 'lodin'
)
Maintainer.create!(
  name: 'Alex Radetsky',
  email: 'rad@altlinux.org',
  login: 'rad'
)
Maintainer.create!(
  name: 'Wartan Hachaturow',
  email: 'wart@altlinux.org',
  login: 'wart'
)
Maintainer.create!(
  name: 'Anton Pischulin',
  email: 'letanton@altlinux.org',
  login: 'letanton'
)
Maintainer.create!(
  name: 'Pavel Isopenko',
  email: 'pauli@altlinux.org',
  login: 'pauli'
)
Maintainer.create!(
  name: 'Mike Radyuk',
  email: 'torabora@altlinux.org',
  login: 'torabora'
)

# TODO: add @xen and @ha-cluster'

Maintainer::Team.create!(
  name: 'TeX Development ::Team',
  email: 'tex@packages.altlinux.org',
  login: '@tex'
)
Maintainer::Team.create!(
  name: 'Connexion Development ::Team',
  email: 'connexion@packages.altlinux.org',
  login: '@connexion'
)
Maintainer::Team.create!(
  name: 'EVMS Development ::Team',
  email: 'evms@packages.altlinux.org',
  login: '@evms'
)
Maintainer::Team.create!(
  name: 'QA ::Team',
  email: 'qa@packages.altlinux.org',
  login: '@qa'
)
Maintainer::Team.create!(
  name: 'CPAN ::Team',
  email: 'cpan@packages.altlinux.org',
  login: '@cpan'
)
Maintainer::Team.create!(
  name: 'Xfce ::Team',
  email: 'xfce@packages.altlinux.org',
  login: '@xfce'
)
Maintainer::Team.create!(
  name: 'VIm Plugins Development ::Team',
  email: 'vim-plugins@packages.altlinux.org',
  login: '@vim-plugins'
)
Maintainer::Team.create!(
  name: 'FreeRadius Development ::Team',
  email: 'freeradius@packages.altlinux.org',
  login: '@freeradius'
)
Maintainer::Team.create!(
  name: 'FTN Development ::Team',
  email: 'ftn@packages.altlinux.org',
  login: '@ftn'
)
Maintainer::Team.create!(
  name: 'Java ::Team',
  email: 'java@packages.altlinux.org',
  login: '@java'
)
Maintainer::Team.create!(
  name: 'Kernel ::Team',
  email: 'kernel@packages.altlinux.org',
  login: '@kernel'
)
Maintainer::Team.create!(
  name: 'Ruby ::Team',
  email: 'ruby@packages.altlinux.org',
  login: '@ruby'
)
Maintainer::Team.create!(
  name: 'Python ::Team',
  email: 'python@packages.altlinux.org',
  login: '@python'
)
Maintainer::Team.create!(
  name: 'QA p6',
  email: 'qa_p6@packages.altlinux.org',
  login: '@qa_p6'
)
Maintainer::Team.create!(
  name: 'QA p5',
  email: 'qa_p5@packages.altlinux.org',
  login: '@qa_p5'
)
end


has_branch_path =
   begin
      BranchPath
   rescue NameError
   end

if Branch.where(name: "Sisyphus_MIPS").blank? and !has_branch_path
   # add MIPS branch
   branch = Branch.new
   branch.vendor = 'ALT Linux'
   branch.name = 'Sisyphus_MIPS'
   branch.order_id = 11
   branch.path = '/ALTmips'
   branch.save!

   Mirror.create! branch_id: branch.id,
                  order_id: 1,
                  name: 'ftp://ftp.altlinux.org',
                  country: 'ru',
                  uri: 'ftp://ftp.altlinux.org/pub/distributions/ALTLinux/ports/mipsel/Sisyphus/',
                  protocol: 'ftp'
end

if BranchPath.all.blank?
   scheme = { "Sisyphus"      => %w(/ALT/Sisyphus/files/#{arch}/RPMS/ i586 x86_64 noarch aarch64),
              "Sisyphus_MIPS" => %w(/ALTmips/files/#{arch}/RPMS/ mipsel noarch),
              "SisyphusARM"   => %w(/ALT/Sisyphus-armh/files/armh/RPMS/ armh noarch),
              "p8"            => %w(/ALT/p8/files/#{arch}/RPMS/ i586 x86_64 noarch),
              "c8.1"          => %w(/ALT/c8.1/files/#{arch}/RPMS/ i586 x86_64 noarch),
              "c8"            => %w(/ALT/c8/files/#{arch}/RPMS/ i586 x86_64 noarch),
              "p7"            => %w(/ALT/p7/files/#{arch}/RPMS/ i586 x86_64 noarch ),
              "c7.1"          => %w(/ALT/c7.1/files/#{arch}/RPMS/ i586 x86_64 noarch),
              "c7"            => %w(/ALT/c7/files/#{arch}/RPMS/ i586 x86_64 noarch),
              "Platform6"     => %w(/ALT/p6/files/#{arch}/RPMS/ i586 x86_64 noarch),
              "c6"            => %w(/ALT/c6/files/#{arch}/RPMS/ i586 x86_64 noarch),
              "Platform5"     => %w(/ALT/p5/files/#{arch}/RPMS/ i586 x86_64 noarch),
              "5.1"           => %w(/ALT/5.1/files/#{arch}/RPMS/ i586 x86_64 noarch),
   }

   scheme.each do |branch_name, arches|
      path = arches.shift

      branch = Branch.where(name: branch_name).first

      arches.each do |arch|
         FactoryBot.create(:branch_path, branch: branch,
                                         arch: arch,
                                         path: eval("\"#{path}\""))
      end
   end
end

if BranchPath.source.blank?
   scheme = { "Sisyphus"      => %w(/ALT/Sisyphus/files/SRPMS/ true),
              "Sisyphus_MIPS" => %w(/ALTmips/files/SRPMS/ true),
              "SisyphusARM"   => %w(/ALT/Sisyphus-armh/files/armh/SRPMS/ false),
              "p8"            => %w(/ALT/p8/files/SRPMS/ true),
              "p7"            => %w(/ALT/p7/files/SRPMS/ true),
              "t7"            => %w(/ALT/t7/files/SRPMS/ true),
              "Platform6"     => %w(/ALT/p6/files/SRPMS/ true),
              "t6"            => %w(/ALT/t6/files/SRPMS/ true),
              "Platform5"     => %w(/ALT/p5/files/SRPMS/ true),
              "5.1"           => %w(/ALT/5.1/files/SRPMS/ true),
   }

   scheme.each do |branch_name, arches|
      path = arches.shift
      active = eval(arches.shift)

      branch = Branch.where(name: branch_name).first

      bp = FactoryBot.create(:branch_path, branch: branch,
                                           arch: "src",
                                           path: path,
                                           active: active)
      # update source_path
      BranchPath.where(branch: branch).where.not(arch: "src").update_all(source_path_id: bp.id)
   end

   # merge SisyphusARM and Sisyphus_MIPS to Sisyphus
   branch_id = Branch.where(name: %w(Sisyphus)).pluck(:id).first
   branches = Branch.where(name: %w(SisyphusARM Sisyphus_MIPS))
   BranchPath.where(branch: branches).update_all(branch_id: branch_id)
   BranchPath.where(source_path_id: BranchPath.source.where(active: false).first).update_all(active: false)
   branches.delete_all
end

BranchPath.transaction do
   BranchPath.where(name: nil).each do |branch_path|
      base = case branch_path.path
             when /^\/ALT\/([\w\-\.]+)\//
                $1
             when /^\/(\w+)\//
                $1 == "ALTmips" && "Sisyphus MIPSEL" || $1
             else
                raise branch_path.path
             end

      name = branch_path.arch == "src" && base || "#{base} (#{branch_path.arch})"
      branch_path.update!(name: name)
   end
end

BranchPath.transaction do
   BranchPath.where.not(srpms_count: 0).each do |branch_path|
      time = Time.gm(2018, 8, 6, 0, 0, 0)
      if branch_path.imported_at < time
         branch_path.update(imported_at: time)
      end
   end
end

if BranchPath.source.blank?
   Branch.transaction do
      {
         'c8.1' => {
            'src' => %w(/ALT/c8.1/files/SRPMS),
            'i586' => %w(/ALT/c8.1/files/i586/RPMS),
            'x86_64' => %w(/ALT/c8.1/files/x86_64/RPMS),
            'noarch' => %w(/ALT/c8.1/files/noarch/RPMS),
         },
         'c8' => {
            'src' => %w(/mnt/ftp/c8/SRPMS /mnt/ftp/c8/armh/SRPMS),
            'i586' => %w(/mnt/ftp/c8/i586/RPMS),
            'x86_64' => %w(/mnt/ftp/c8/x86_64/RPMS),
            'armh' => %(/mnt/ftp/c8/files/armh/RPMS),
            'noarch' => %w(/mnt/ftp/c8/noarch/RPMS),
         },
         'c7.1' => {
            'src' => %w(/ALT/c7.1/files/SRPMS),
            'i586' => %w(/ALT/c7.1/files/i586/RPMS),
            'x86_64' => %w(/ALT/c7.1/files/x86_64/RPMS),
            'noarch' => %w(/ALT/c7.1/files/noarch/RPMS),
         },
         'c7' => {
            'src' => %w(/mnt/ftp/c7/SRPMS /mnt/ftp/c7/armh/SRPMS),
            'i586' => %w(/mnt/ftp/c7/i586/RPMS),
            'x86_64' => %w(/mnt/ftp/c7/x86_64/RPMS),
            'arm' => %w(/mnt/ftp/c7arm/RPMS),
            'armh' => %w(/mnt/ftp/c7armh/RPMS),
            'noarch' => %w(/mnt/ftp/c7/noarch/RPMS),
         },
         't7' => {
            'src' => %w(/mnt/ftp/t7/SRPMS),
            'i586' => %w(/mnt/ftp/t7/i586/RPMS),
            'x86_64' => %w(/mnt/ftp/t7/x86_64/RPMS),
            'arm' => %w(/mnt/ftp/t7/arm/RPMS),
            'armh' => %w(/mnt/ftp/t7/armh/RPMS),
            'noarch' => %w(/mnt/ftp/t7/noarch/RPMS),
         },
         'c6' => {
            'src' => %w(/ALT/c6/files/SRPMS),
            'i586' => %w(/ALT/c6/files/i586/RPMS),
            'x86_64' => %w(/ALT/c6/files/x86_64/RPMS),
            'noarch' => %w(/ALT/c6/files/noarch/RPMS),
         },
         't6' => {
            'src' => %w(/mnt/ftp/t6/SRPMS),
            'i586' => %w(/mnt/ftp/t6/i586/RPMS),
            'x86_64' => %w(/mnt/ftp/t6/x86_64/RPMS),
            'noarch' => %w(/mnt/ftp/t6/noarch/RPMS),
         },
         '5.1' => {
            'src' => %w(/ALT/5.1/files/SRPMS),
            'i586' => %w(/ALT/5.1/files/i586/RPMS),
            'x86_64' => %w(/ALT/5.1/files/x86_64/RPMS),
            'noarch' => %w(/ALT/5.1/files/noarch/RPMS),
         },
         'p5' => {
            'src' => %w(/mirror/p5/files/SRPMS),
            'i586' => %w(/mirror/p5/files/i586/RPMS),
            'x86_64' => %w(/mirror/p5/files/x86_64/RPMS),
            'noarch' => %w(/mirror/p5/files/noarch/RPMS),
         }
      }.each do |name, arches|
         branch = Branch.find_or_create_by!(name: name, vendor: "ALT Linux")

         arches.each do |arch, paths|
            pname = arch == "src" && name || "#{name} (#{arch})"
            [ paths ].flatten.each do |path|
               attrs = { name: pname, arch: arch, path: path, branch_id: branch.id }
               attrs[:source_path_id] = BranchPath.where(path: arches['src'].first).first.id if arch != "src"

               BranchPath.create!(attrs)
            end
         end
      end
   end
end
