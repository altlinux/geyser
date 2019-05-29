class BranchPath < ApplicationRecord
  ARCHES = %w(i586 x86_64 aarch64 mipsel armh riscv64 ppc64le e2k e2kv4 src noarch)
  PHYS_ARCHES = %w(i586 x86_64 aarch64 mipsel armh riscv64 ppc64le e2k e2kv4)

  belongs_to :branch
  belongs_to :source_path, foreign_key: :source_path_id, class_name: :BranchPath, optional: true

  has_many :rpms, inverse_of: :branch_path
  has_many :packages, through: :rpms
  has_many :builders, -> { distinct }, through: :packages
  has_many :build_paths, foreign_key: :source_path_id, class_name: :BranchPath
  has_many :srpm_filenames, -> { src.select(:filename).distinct }, through: :rpms, source: :branch_path
  has_many :ftbfs, class_name: 'Issue::Ftbfs'

  scope :src, -> { where(arch: "src") }
  scope :built, -> { where.not(arch: "src") }
  scope :active, -> { where(active: true) }
  scope :phys, -> { where.not(arch: %w(src noarch)) }
  scope :unanonimous, -> { where.not(name: nil) }
  scope :for_branch, ->(branch) { where(branch_id: branch) }
  scope :with_arch, ->(arch) { where(arch: arch) }
  scope :primary, -> { where(primary: true) }
  scope :published, -> { where.not(ftp_url: nil) }
  scope :for, ->(arch) do
#     SELECT * FROM branch_paths a LEFT OUTER JOIN branch_paths b ON a.source_path_id = b.source_path_id OR b.source_path_id = a.id WHERE b.arch = 'mipsel';
     self.select("branch_paths_a.*")
         .from("branch_paths AS branch_paths_a")
         .joins("INNER JOIN branch_paths AS branch_paths_b
                         ON branch_paths_a.source_path_id = branch_paths_b.source_path_id
                         OR branch_paths_b.source_path_id = branch_paths_a.id")
         .where(Arel.sql(sanitize_sql_array(["branch_paths_b.arch = ?", arch])))
  end

  validates_presence_of :branch, :arch, :path
  validates_presence_of :source_path, if: -> { arch != "src" }
  validates_inclusion_of :arch, in: ARCHES

  validate :validate_path_existence

  def glob
    "*.#{arch}.rpm"
  end

  def empty?
    srpms_count == 0
  end

  protected

  def validate_path_existence
     if self.path && !File.directory?(self.path)
        self.errors.add(:path, "#{self.path} is not exist or folder")
     end
  end
end
