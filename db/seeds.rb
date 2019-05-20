# frozen_string_literal: true

if Branch.all.blank?
# add Sisyphus branch
branch = Branch.new
branch.vendor = 'ALT'
branch.name = 'Sisyphus'
branch.order_id = 0
branch.path = '/Sisyphus'
# branch.srpm_path = ['/ALT/Sisyphus/files/SRPMS']
branch.save!

# add SisyphusARM branch
branch = Branch.new
branch.vendor = 'ALT'
branch.name = 'SisyphusARM'
branch.order_id = 1
branch.path = '/Sisyphus'
# branch.srpm_path = []
branch.save!

# add Platform8 branch
branch = Branch.new
branch.vendor = 'ALT'
branch.name = 'p8'
branch.order_id = 2
branch.path = '/p8/branch'
branch.save!

# add Platform7 branch
branch = Branch.new
branch.vendor = 'ALT'
branch.name = 'p7'
branch.order_id = 3
branch.path = '/p7/branch'
branch.save!

# add t7 branch
branch = Branch.new
branch.vendor = 'ALT'
branch.name = 't7'
branch.order_id = 4
branch.path = '/t7/branch'
branch.save!

# add Platform6 branch
branch = Branch.new
branch.vendor = 'ALT'
branch.name = 'Platform6'
branch.order_id = 5
branch.path = '/p6/branch'
branch.save!

# add t6 branch
branch = Branch.new
branch.vendor = 'ALT'
branch.name = 't6'
branch.order_id = 6
branch.path = '/t6/branch'
branch.save!

# add Platform5 branch
branch = Branch.new
branch.vendor = 'ALT'
branch.name = 'Platform5'
branch.order_id = 7
branch.path = '/p5/branch'
branch.save!

# add 5.1 branch
branch = Branch.new
branch.vendor = 'ALT'
branch.name = '5.1'
branch.order_id = 8
branch.path = '/5.1/branch'
branch.save!

# add 5.0 branch
branch = Branch.new
branch.vendor = 'ALT'
branch.name = '5.0'
branch.order_id = 9
branch.path = '/5.0/branch'
branch.save!

# add 4.1 branch
branch = Branch.new
branch.vendor = 'ALT'
branch.name = '4.1'
branch.order_id = 10
branch.path = '/4.1/branch'
branch.save!

# add 4.0 branch
branch = Branch.new
branch.vendor = 'ALT'
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
branch = Branch.find_by(name: 'Sisyphus', vendor: 'ALT')
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
# branch = Branch.find_by(name: 'SisyphusARM', vendor: 'ALT')
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
branch = Branch.find_by(name: 'p8', vendor: 'ALT')
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
branch = Branch.find_by(name: 'p7', vendor: 'ALT')
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
branch = Branch.find_by(name: 't7', vendor: 'ALT')
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
branch = Branch.find_by(name: 'Platform6', vendor: 'ALT')
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
branch = Branch.find_by(name: 't6', vendor: 'ALT')
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
branch = Branch.find_by(name: 'Platform5', vendor: 'ALT')
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
branch = Branch.find_by(name: '5.1', vendor: 'ALT')
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
branch = Branch.find_by(name: '5.0', vendor: 'ALT')
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
branch = Branch.find_by(name: '4.1', vendor: 'ALT')
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
branch = Branch.find_by(name: '4.0', vendor: 'ALT')
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
   branch.vendor = 'ALT'
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

if BranchPath.src.blank?
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
   BranchPath.where(source_path_id: BranchPath.src.where(active: false).first).update_all(active: false)
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

if BranchPath.src.blank?
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
         branch = Branch.find_or_create_by!(name: name, vendor: "ALT")

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

if BranchPath.where.not(ftbfs_stat_uri: nil).blank?
   BranchPath.transaction do
      uris = {
         'Sisyphus' => [
            %w(http://git.altlinux.org/beehive/stats/Sisyphus-i586/ftbfs-joined i586),
            %w(http://git.altlinux.org/beehive/stats/Sisyphus-x86_64/ftbfs-joined x86_64),
         ],
         'p8' => [
            %w(http://git.altlinux.org/beehive/stats/p8-i586/ftbfs-joined i586),
            %w(http://git.altlinux.org/beehive/stats/p8-x86_64/ftbfs-joined x86_64),
         ],
         'c7' => [
            %w(http://git.altlinux.org/beehive/stats/c7-i586/ftbfs-joined i586),
            %w(http://git.altlinux.org/beehive/stats/c7-x86_64/ftbfs-joined x86_64),
         ],
         'p7' => [
            %w(http://git.altlinux.org/beehive/stats/p7-i586/ftbfs-joined i586),
            %w(http://git.altlinux.org/beehive/stats/p7-x86_64/ftbfs-joined x86_64),
         ],
         'p6' => [
            %w(http://git.altlinux.org/beehive/stats/p6-i586/ftbfs-joined i586),
            %w(http://git.altlinux.org/beehive/stats/p6-x86_64/ftbfs-joined x86_64),
         ],
         't6' => [
            %w(http://git.altlinux.org/beehive/stats/t6-i586/ftbfs-joined i586),
            %w(http://git.altlinux.org/beehive/stats/t6-x86_64/ftbfs-joined x86_64),
         ]
      }

      uris.each do |branch_name, arches|
         arches.each do |(uri, arch)|
            branch_paths = BranchPath.joins(:branch).where(arch: arch, branches: { name: branch_name})
            branch_path = branch_paths.find {|bp| bp.source_path.primary }
            branch_path.update_attribute(:ftbfs_stat_uri, uri)
         end
      end
   end
end

if BranchPath.where.not(ftbfs_uri: nil).blank?
   BranchPath.transaction do
      urls = {
         'Sisyphus' => [
            %w(/beehive/logs/Sisyphus-i586/latest/error/ i586),
            %w(/beehive/logs/Sisyphus-x86_64/latest/error/ x86_64),
         ],
         'p8' => [
            %w(/beehive/logs/p8-i586/latest/error/ i586),
            %w(/beehive/logs/p8-x86_64/latest/error/ x86_64),
         ],
         'c7' => [
            %w(/beehive/logs/c7-i586/latest/error/ i586),
            %w(/beehive/logs/c7-x86_64/latest/error/ x86_64),
         ],
         'p7' => [
            %w(/beehive/logs/p7-i586/latest/error/ i586),
            %w(/beehive/logs/p7-x86_64/latest/error/ x86_64),
         ],
         'p6' => [
            %w(/beehive/logs/p6-i586/latest/error/ i586),
            %w(/beehive/logs/p6-x86_64/latest/error/ x86_64),
         ],
         't6' => [
            %w(/beehive/logs/t6-i586/latest/error/ i586),
            %w(/beehive/logs/t6-x86_64/latest/error/ x86_64),
         ]
      }

      urls.each do |branch_name, arches|
         arches.each do |(url, arch)|
            branch_paths = BranchPath.joins(:branch).where(arch: arch, branches: { name: branch_name})
            branch_path = branch_paths.find {|bp| bp.source_path.primary }
            branch_path.update_attribute(:ftbfs_uri, url)
         end
      end
   end
end
if BranchPath.where.not(ftp_url: nil).blank?
   require 'open-uri'

   BranchPath.transaction do
      paths = ["/ALT/p7/files/x86_64/RPMS/",
         "/ALT/Sisyphus-armh/files/armh/SRPMS/",
         "/ALT/5.1/files/noarch/RPMS",
         "/ALT/5.1/files/i586/RPMS",
         "/mnt/ftp/c8/i586/RPMS",
         "/mnt/ftp/c8/x86_64/RPMS",
         "/mnt/ftp/t6/noarch/RPMS",
         "/ALT/Sisyphus/files/i586/RPMS/",
         "/mirror/p5/files/noarch/RPMS",
         "/mnt/ftp/t7/x86_64/RPMS",
         "/mnt/ftp/t7/i586/RPMS",
         "/ALT/c8.1/files/i586/RPMS",
         "/mirror/p5/files/x86_64/RPMS",
         "/mirror/p5/files/i586/RPMS",
         "/mnt/ftp/c7/noarch/RPMS",
         "/ALTmips/files/noarch/RPMS/",
         "/ALT/c7.1/files/x86_64/RPMS",
         "/ALT/Sisyphus-armh/files/armh/RPMS/",
         "/ALT/p8/files/i586/RPMS/",
         "/mnt/ftp/c8/noarch/RPMS",
         "/mnt/ftp/t7/noarch/RPMS",
         "/ALT/c7.1/files/noarch/RPMS",
         "/ALTmips/files/SRPMS/",
         "/ALTmips/files/mipsel/RPMS/",
         "/ALT/c6/files/x86_64/RPMS",
         "/mnt/ftp/c7/i586/RPMS",
         "/mnt/ftp/c7/x86_64/RPMS",
         "/ALT/c8.1/files/noarch/RPMS",
         "/ALT/c7.1/files/i586/RPMS",
         "/ALT/5.1/files/x86_64/RPMS",
         "/ALT/Sisyphus/files/aarch64/RPMS/",
         "/ALT/p8/files/x86_64/RPMS/",
         "/ALT/Sisyphus-armh/files/armh/RPMS/",
         "/ALT/p6/files/i586/RPMS/",
         "/ALT/p6/files/noarch/RPMS/",
         "/ALT/p7/files/noarch/RPMS/",
         "/ALT/c6/files/i586/RPMS",
         "/ALT/c8.1/files/x86_64/RPMS",
         "/ALT/Sisyphus/files/noarch/RPMS/",
         "/ALT/Sisyphus/files/x86_64/RPMS/",
         "/ALT/p6/files/x86_64/RPMS/",
         "/ALT/p7/files/i586/RPMS/",
         "/mnt/ftp/t6/i586/RPMS",
         "/ALT/p8/files/noarch/RPMS/",
         "/ALT/Sisyphus/files/SRPMS/",
         "/mnt/ftp/t6/x86_64/RPMS",
         "/ALT/p6/files/SRPMS/",
         "/ALT/p7/files/SRPMS/",
         "/ALT/p8/files/SRPMS/",
         "/ALT/c8.1/files/SRPMS",
         "/ALT/c7.1/files/SRPMS",
         "/ALT/5.1/files/SRPMS",
         "/mirror/p5/files/SRPMS",
         "/ALT/c6/files/SRPMS",
         "/ALT/c6/files/noarch/RPMS",
         "/mnt/ftp/c8/SRPMS",
         "/mnt/ftp/c7/SRPMS",
         "/mnt/ftp/t7/SRPMS",
         "/mnt/ftp/t6/SRPMS"]

      ftps = ["http://ftp.altlinux.org/pub/distributions/ALTLinux/p7/branch/files/x86_64/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/Sisyphus/files/armh/SRPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/5.1/branch/files/noarch/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/5.1/branch/files/i586/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/c8/branch/files/i586/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/c8/branch/files/x86_64/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/t6/branch/files/noarch/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/Sisyphus/files/i586/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p5/branch/files/noarch/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/t7/branch/files/x86_64/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/t7/branch/files/i586/RPMS",
         nil,
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p5/branch/files/x86_64/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p5/branch/files/i586/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/c7/branch/files/noarch/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/ports/mipsel/Sisyphus/files/noarch/RPMS/",
         nil,
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/Sisyphus/files/armh/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p8/branch/files/i586/RPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/c8/branch/files/noarch/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/t7/branch/files/noarch/RPMS",
         nil,
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/ports/mipsel/Sisyphus/files/SRPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/ports/mipsel/Sisyphus/files/mipsel/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/c6/branch/files/x86_64/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/c7/branch/files/i586/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/c7/branch/files/x86_64/RPMS",
         nil,
         nil,
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/5.1/branch/files/x86_64/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/Sisyphus/files/aarch64/RPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p8/branch/files/x86_64/RPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/Sisyphus/files/armh/RPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p6/branch/files/i586/RPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p6/branch/files/noarch/RPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p7/branch/files/noarch/RPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/c6/branch/files/i586/RPMS",
         nil,
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/Sisyphus/files/noarch/RPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/Sisyphus/files/x86_64/RPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p6/branch/files/x86_64/RPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p7/branch/files/i586/RPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/t6/branch/files/i586/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p8/branch/files/noarch/RPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/Sisyphus/files/SRPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/t6/branch/files/x86_64/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p6/branch/files/SRPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p7/branch/files/SRPMS/",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p8/branch/files/SRPMS/",
         nil,
         nil,
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/5.1/branch/files/SRPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/p5/branch/files/SRPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/c6/branch/files/SRPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/c6/branch/files/noarch/RPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/c8/branch/files/SRPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/c7/branch/files/SRPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/t7/branch/files/SRPMS",
         "http://ftp.altlinux.org/pub/distributions/ALTLinux/t6/branch/files/SRPMS"]

      [ paths, ftps ].transpose.each do |(path, ftp)|
         puts path
         puts ftp
         open(ftp) if ftp
         BranchPath.where(path: path).each do |bp|
            bp.update_attribute(:ftp_url, ftp)
         end
      end
   end
end

if  BranchPath.where.not(team_url: nil).blank?
   Branch.find_each do |branch|
      branch_path = branch.branch_paths.src.first

      url = "http://git.altlinux.org/acl/list.groups.#{branch.name.downcase}"

      begin
         open(URI.escape(url))
      rescue OpenURI::HTTPError
      else
         branch_path.update_attribute(:team_url, url)
      end
   end
end

if BranchPath.src.where("name ~ 'ports'").blank?
   BranchPath.transaction do
      {
         'sisyphus' => {
             'ports (aarch64)' => %w(src /ports/aarch64/sisyphus/files/SRPMS),
             'ports (aarch64/aarch64)' => %w(aarch64 /ports/aarch64/sisyphus/files/aarch64/RPMS /ports/aarch64/sisyphus/files/SRPMS),
             'ports (aarch64/noarch)' => %w(noarch /ports/aarch64/sisyphus/files/aarch64/RPMS /ports/aarch64/sisyphus/files/SRPMS),
             'ports (armh)' => %w(src /ports/armh/sisyphus/files/SRPMS),
             'ports (armh/armh)' => %w(armh /ports/armh/sisyphus/files/armh/RPMS /ports/armh/sisyphus/files/SRPMS),
             'ports (armh/noarch)' => %w(noarch /ports/armh/sisyphus/files/armh/RPMS /ports/armh/sisyphus/files/SRPMS),
             'ports (mipsel)' => %w(src /ports/mipsel/sisyphus/files/SRPMS),
             'ports (mipsel/mipsel)' => %w(mipsel /ports/mipsel/sisyphus/files/mipsel/RPMS /ports/mipsel/sisyphus/files/SRPMS),
             'ports (mipsel/noarch)' => %w(noarch /ports/mipsel/sisyphus/files/noarch/RPMS /ports/mipsel/sisyphus/files/SRPMS),
             'autoimports' => %w(src /roland/autoimports/ALTLinux/autoimports/Sisyphus/files/SRPMS),
         },
         'p8' => {
             'autoimports' => %w(src /roland/autoimports/ALTLinux/autoimports/p8/files/SRPMS),
         },
         'p7' => {
             'autoimports' => %w(src /roland/autoimports/ALTLinux/autoimports/p7/files/SRPMS),
         },
      }.each do |branch_slug, source|
         branch = Branch.find_by!(slug: branch_slug)

         source.each do |name, (arch, path, src_path)|
            bp = BranchPath.find_or_create_by!(path: path, arch: arch) do |bp|
               bp.name = name
               bp.branch = branch
               bp.source_path = BranchPath.find_by!(arch: "src", path: src_path) if src_path
            end
         end
      end
   end
end

if Branch.where(slug: 'icarus').blank?
   branch = Branch.create!(slug: 'icarus', name: 'Icarus', vendor: 'ALT Linux')
   branch.branch_paths.create(arch: 'src', path: '/ALT/Sisyphus', active: false, name: 'Icarus [src]', primary: true)
end

if BranchPath.where.not(ftbfs_stat_since_uri: nil).blank?
   BranchPath.transaction do
      uris = {
         'Sisyphus' => [
            %w(http://git.altlinux.org/beehive/stats/Sisyphus-i586/ftbfs-since i586),
            %w(http://git.altlinux.org/beehive/stats/Sisyphus-x86_64/ftbfs-since x86_64),
         ],
         'p8' => [
            %w(http://git.altlinux.org/beehive/stats/p8-i586/ftbfs-since i586),
            %w(http://git.altlinux.org/beehive/stats/p8-x86_64/ftbfs-since x86_64),
         ],
         'c7' => [
            %w(http://git.altlinux.org/beehive/stats/c7-i586/ftbfs-since i586),
            %w(http://git.altlinux.org/beehive/stats/c7-x86_64/ftbfs-since x86_64),
         ],
         'p7' => [
            %w(http://git.altlinux.org/beehive/stats/p7-i586/ftbfs-since i586),
            %w(http://git.altlinux.org/beehive/stats/p7-x86_64/ftbfs-since x86_64),
         ],
         'p6' => [
            %w(http://git.altlinux.org/beehive/stats/p6-i586/ftbfs-since i586),
            %w(http://git.altlinux.org/beehive/stats/p6-x86_64/ftbfs-since x86_64),
         ],
         't6' => [
            %w(http://git.altlinux.org/beehive/stats/t6-i586/ftbfs-since i586),
            %w(http://git.altlinux.org/beehive/stats/t6-x86_64/ftbfs-since x86_64),
         ]
      }

      uris.each do |branch_name, arches|
         arches.each do |(uri, arch)|
            branch_paths = BranchPath.joins(:branch).where(arch: arch, branches: { name: branch_name })
            branch_path = branch_paths.find {|bp| bp.source_path.primary }
            branch_path.update_attribute(:ftbfs_stat_since_uri, uri)
         end
      end
   end
end

if Branch.where.not(archive_uri: nil).blank?
   Branch.transaction do
      uris = {
         'Sisyphus' => [
            %w(http://ftp.altlinux.org/pub/distributions/archive/sisyphus/index/src/ src),
         ],
         'p8' => [
            %w(http://ftp.altlinux.org/pub/distributions/archive/p8/index/src/ src),
         ],
         'p7' => [
            %w(http://ftp.altlinux.org/pub/distributions/archive/p7/index/src/ src),
         ],
         't7' => [
            %w(http://ftp.altlinux.org/pub/distributions/archive/t7/index/src/ src),
         ]
      }

      uris.each do |branch_name, arches|
         arches.each do |(uri, arch)|
            branch_path = BranchPath.joins(:branch).where(arch: arch, branches: { name: branch_name }).primary.first
            branch_path.branch.update_attribute(:archive_uri, uri)
         end
      end
   end
end

if BranchPath.where(name: 'p9').blank?
   Branch.transaction do
      {
         'p9' => {
            'p9-src' => %w(src /ALT/p9/files/SRPMS http://ftp.altlinux.org/pub/distributions/ALTLinux/p9/branch/files/SRPMS/),
            'p9 i586' => %w(i586 /ALT/p9/files/i586/RPMS http://ftp.altlinux.org/pub/distributions/ALTLinux/p9/branch/files/i586/RPMS/ p9-src),
            'p9 x86_64' => %w(x86_64 /ALT/p9/files/x86_64/RPMS http://ftp.altlinux.org/pub/distributions/ALTLinux/p9/branch/files/x86_64/RPMS/ p9-src),
            'p9 aarch64' => %w(aarch64 /ALT/p9/files/aarch64/RPMS http://ftp.altlinux.org/pub/distributions/ALTLinux/p9/branch/files/aarch64/RPMS/ p9-src),
            'p9 noarch' => %w(noarch /ALT/p9/files/noarch/RPMS http://ftp.altlinux.org/pub/distributions/ALTLinux/p9/branch/files/noarch/RPMS/ p9-src),
            'p9-armh' => %w(src /mnt/p9/armh http://ftp.altlinux.org/pub/distributions/ALTLinux/p9/ports/armh/files/SRPMS/),
            'p9 arch-armh' => %w(armh /mnt/p9/armh/arch http://ftp.altlinux.org/pub/distributions/ALTLinux/p9/ports/armh/files/armh/RPMS/ p9-armh),
            'p9 noarch-armh' => %w(noarch /mnt/p9/armh/noarch http://ftp.altlinux.org/pub/distributions/ALTLinux/p9/ports/armh/files/noarch/RPMS/ p9-armh),
            'p9-mipsel' => %w(src /mnt/p9/mipsel http://ftp.altlinux.org/pub/distributions/ALTLinux/p9/ports/mipsel/files/SRPMS/),
            'p9 arch-mipsel' => %w(mipsel /mnt/p9/mipsel/arch http://ftp.altlinux.org/pub/distributions/ALTLinux/p9/ports/mipsel/files/mipsel/RPMS/ p9-mipsel),
            'p9 noarch-mipsel' => %w(noarch /mnt/p9/mipsel/noarch http://ftp.altlinux.org/pub/distributions/ALTLinux/p9/ports/mipsel/files/noarch/RPMS/ p9-mipsel),
         },
      }.each do |name, arches|
         branch = Branch.find_or_create_by!(name: name, vendor: "ALT", slug: name)

         arches.each.with_index do |(pname, (arch, path, ftp, src_name)), index|
            attrs = { name: pname, arch: arch, path: path, branch_id: branch.id, ftp_url: ftp, primary: index == 0 }
            attrs[:source_path_id] = BranchPath.where(name: src_name).first.id if src_name

            BranchPath.create!(attrs)
         end
      end
   end
end
