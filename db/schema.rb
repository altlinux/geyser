# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_09_144600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gin"
  enable_extension "btree_gist"
  enable_extension "ltree"
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "acls", force: :cascade do |t|
    t.bigint "branch_path_id", comment: "Ссылка на путь ветви"
    t.string "maintainer_slug", comment: "Имя сопровождающего для пакета"
    t.string "package_name", comment: "Имя пакета"
    t.boolean "owner", default: false, comment: "Владелец ли пакета?"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_path_id"], name: "index_acls_on_branch_path_id"
    t.index ["maintainer_slug"], name: "index_acls_on_maintainer_slug"
    t.index ["package_name", "maintainer_slug", "branch_path_id"], name: "index_acls_on_three_fields", unique: true
    t.index ["package_name"], name: "index_acls_on_package_name"
  end

  create_table "branch_groups", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "branch_id"
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "srpms_count", default: 0, comment: "Счётчик именованных исходных пакетов для группы"
    t.bigint "group_id", null: false, comment: "Ссылка на группу"
    t.index ["branch_id", "group_id"], name: "index_branch_groups_on_branch_id_and_group_id", unique: true
    t.index ["branch_id"], name: "index_branch_groups_on_branch_id"
    t.index ["group_id"], name: "index_branch_groups_on_group_id"
    t.index ["parent_id"], name: "index_branch_groups_on_parent_id"
  end

  create_table "branch_paths", force: :cascade do |t|
    t.string "arch", comment: "Архитектура, используемая для ветви"
    t.string "path", comment: "Путь ко хранилищу rpm-пакетов для архитектуры"
    t.bigint "branch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "source_path_id", comment: "Указатель на путь к ветви родительских пакетов"
    t.boolean "active", default: true, comment: "Флаг задействования пути ветви, если установлен, то путь активен"
    t.string "name", comment: "Имя пути ветви"
    t.integer "srpms_count", default: 0, comment: "Счётчик именованных исходных пакетов для пути ветви"
    t.datetime "imported_at", default: "1970-01-01 00:00:00", null: false, comment: "Время последнего импорта пакетов для пути ветви"
    t.string "acl_url", comment: "Внешняя ссылка на список прав на доступ"
    t.string "team_url", comment: "Внешняя ссылка на список групп ветви"
    t.string "ftbfs_stat_uri", comment: "Ссылка в пучине на ftbfs для источника ветви"
    t.boolean "primary", default: false, null: false, comment: "Первичный источник пакетов для ветви"
    t.string "ftbfs_uri", comment: "Внешная изворная ссылка на ftbfs для источника ветви"
    t.index ["arch", "branch_id", "source_path_id"], name: "index_branch_paths_on_arch_and_branch_id_and_source_path_id", unique: true
    t.index ["arch", "path"], name: "index_branch_paths_on_arch_and_path", unique: true
    t.index ["arch"], name: "index_branch_paths_on_arch", using: :gin
    t.index ["branch_id"], name: "index_branch_paths_on_branch_id"
    t.index ["name"], name: "index_branch_paths_on_name"
    t.index ["path"], name: "index_branch_paths_on_path", using: :gin
    t.index ["source_path_id"], name: "index_branch_paths_on_source_path_id"
  end

  create_table "branches", id: :serial, force: :cascade do |t|
    t.string "vendor", limit: 255
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "order_id"
    t.string "path", limit: 255
    t.integer "srpms_count", default: 0, comment: "Счётчик уникальных исходных пакетов для ветви"
    t.string "slug", null: false, comment: "Плашка для обращения к ветви в строке пути браузера"
    t.index ["name"], name: "index_branches_on_name"
    t.index ["slug"], name: "index_branches_on_slug", unique: true
  end

  create_table "branching_maintainers", force: :cascade do |t|
    t.bigint "branch_id"
    t.bigint "maintainer_id"
    t.integer "srpms_count", default: 0, null: false, comment: "Счётчик уникальных исходных пакетов, собранных поставщиком для ветви"
    t.index ["branch_id"], name: "index_branching_maintainers_on_branch_id"
    t.index ["maintainer_id"], name: "index_branching_maintainers_on_maintainer_id"
  end

  create_table "changelogs", id: :serial, force: :cascade do |t|
    t.binary "changelogname"
    t.binary "changelogtext"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "delta", default: true, null: false
    t.bigint "package_id", null: false, comment: "Ссылка на пакет"
    t.bigint "maintainer_id", comment: "Автор изменения в логе"
    t.string "evr", null: false, comment: "Эпоха, версия и релиз"
    t.text "text", comment: "Текст изменений"
    t.datetime "at", null: false, comment: "Время создания записи в логе"
    t.bigint "spkg_id", comment: "Ссылка на исходный пакет, в котором проведены изменения"
    t.index ["maintainer_id"], name: "index_changelogs_on_maintainer_id"
    t.index ["package_id"], name: "index_changelogs_on_package_id"
    t.index ["spkg_id"], name: "index_changelogs_on_spkg_id"
  end

  create_table "conflicts", id: :serial, force: :cascade do |t|
    t.integer "package_id"
    t.string "name", limit: 255
    t.string "version", limit: 255
    t.string "release", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "flags"
    t.integer "epoch"
    t.index ["package_id"], name: "index_conflicts_on_package_id"
  end

  create_table "freshmeats", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "version", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ftbfs", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "version", limit: 255
    t.string "release", limit: 255
    t.integer "weeks"
    t.integer "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "arch", limit: 255
    t.integer "maintainer_id"
    t.integer "epoch"
    t.index ["branch_id"], name: "index_ftbfs_on_branch_id"
    t.index ["maintainer_id"], name: "index_ftbfs_on_maintainer_id"
  end

  create_table "gear_maintainers", force: :cascade do |t|
    t.bigint "gear_id"
    t.bigint "maintainer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gear_id", "maintainer_id"], name: "index_gear_maintainers_on_gear_id_and_maintainer_id", unique: true
    t.index ["gear_id"], name: "index_gear_maintainers_on_gear_id"
    t.index ["maintainer_id"], name: "index_gear_maintainers_on_maintainer_id"
  end

  create_table "gears", force: :cascade do |t|
    t.string "reponame", null: false, comment: "Имя пакета"
    t.string "url", null: false, comment: "Внешняя ссылка к ресурсу на сервере"
    t.string "kind", null: false, comment: "Вид ресурса gear или srpm"
    t.datetime "changed_at", null: false, comment: "Время изменения"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reponame"], name: "index_gears_on_reponame"
    t.index ["url"], name: "index_gears_on_url", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.ltree "path", null: false, comment: "Полный путь группы"
    t.string "slug", null: false, comment: "Плашка группы"
    t.string "name", null: false, comment: "Наименование группы"
    t.string "name_en", null: false
    t.index ["path"], name: "gist_index_groups_on_path", using: :gist
    t.index ["path"], name: "index_groups_on_path"
    t.index ["slug"], name: "index_groups_on_slug", unique: true
  end

  create_table "issue_assignees", force: :cascade do |t|
    t.bigint "issue_id", null: false, comment: "Ссылка на вопрос"
    t.bigint "maintainer_id", null: false, comment: "Ссылка на сопроводителя вопроса"
    t.index ["issue_id", "maintainer_id"], name: "index_issue_assignees_on_issue_id_and_maintainer_id", unique: true
    t.index ["issue_id"], name: "index_issue_assignees_on_issue_id"
    t.index ["maintainer_id"], name: "index_issue_assignees_on_maintainer_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "type", null: false, comment: "Тип проблемы"
    t.string "no", null: false, comment: "Номер проблемы, уникальный в паре с типом"
    t.string "status", null: false, comment: "Статус проблемы: новая, разрешена и т.п."
    t.string "resolution", comment: "Описание разрешенности проблемы"
    t.string "severity", null: false, comment: "Серьезность проблемы"
    t.string "repo_name", comment: "RPM-пакет, к которому относится проблема"
    t.string "reporter", null: false, comment: "Почта отчитавшегося о решении проблемы"
    t.text "description", comment: "Описание проблемы"
    t.string "evr", comment: "Эпоха, справа, выпуск пакета"
    t.datetime "resolved_at", comment: "Время разрешения вопроса"
    t.bigint "branch_path_id", null: false, comment: "Ссылка на источник ветви, к которой относится вопрос"
    t.datetime "reported_at", comment: "Время, когда был получен отчет об ошибке"
    t.string "log_url", comment: "Пучинная ссылка на лог сборки пакета или иной лог"
    t.datetime "updated_at", comment: "Время последней пересборки пакета"
    t.string "source_url", comment: "Внешеняя ссылка на пакет-источник вопроса"
    t.index ["branch_path_id"], name: "index_issues_on_branch_path_id"
    t.index ["no"], name: "index_issues_on_no"
    t.index ["repo_name"], name: "index_issues_on_repo_name"
    t.index ["reporter"], name: "index_issues_on_reporter"
    t.index ["resolution"], name: "index_issues_on_resolution"
    t.index ["severity"], name: "index_issues_on_severity"
    t.index ["status"], name: "index_issues_on_status"
    t.index ["type", "no"], name: "index_issues_on_type_and_no", unique: true
    t.index ["type"], name: "index_issues_on_type"
  end

  create_table "maintainers", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255, null: false
    t.string "login", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "time_zone", limit: 255, default: "UTC"
    t.string "jabber", limit: 255, default: ""
    t.text "info", default: ""
    t.string "website", limit: 255, default: ""
    t.string "location", limit: 255, default: ""
    t.integer "srpms_count", default: 0, comment: "Счётчик уникальных исходных пакетов, собранных поставщиком"
    t.string "type", null: false, comment: "Вид сопровождающего: человек или команда"
    t.index ["email"], name: "index_maintainers_on_email", unique: true
    t.index ["login"], name: "index_maintainers_on_login", unique: true
  end

  create_table "mirrors", id: :serial, force: :cascade do |t|
    t.integer "branch_id"
    t.integer "order_id"
    t.string "name", limit: 255
    t.string "country", limit: 255
    t.string "uri", limit: 255
    t.string "protocol", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["branch_id"], name: "index_mirrors_on_branch_id"
  end

  create_table "obsoletes", id: :serial, force: :cascade do |t|
    t.integer "package_id"
    t.string "name", limit: 255
    t.string "version", limit: 255
    t.string "release", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "flags"
    t.integer "epoch"
    t.index ["package_id"], name: "index_obsoletes_on_package_id"
  end

  create_table "packages", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "version", limit: 255
    t.string "release", limit: 255
    t.string "arch", limit: 255, null: false
    t.string "summary", limit: 255
    t.string "license", limit: 255
    t.string "url", limit: 255
    t.text "description"
    t.datetime "buildtime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "group_id", null: false
    t.string "md5", limit: 255, null: false
    t.string "groupname", limit: 255
    t.bigint "size"
    t.integer "epoch"
    t.tsvector "tsv"
    t.string "vendor", comment: "Распространитель пакета"
    t.string "distribution", comment: "Срез набора пакетов"
    t.string "buildhost", comment: "Место сборки пакета"
    t.string "type", null: false, comment: "Вид пакета: исходник или двояк"
    t.bigint "builder_id", null: false, comment: "Собиратель пакета"
    t.integer "src_id", null: false, comment: "Ссылка на исходный пакет, может указывать на самого себя"
    t.integer "repocop_status", default: 0, comment: "Статус проверки репокопом"
    t.index ["arch"], name: "index_packages_on_arch"
    t.index ["builder_id"], name: "index_packages_on_builder_id"
    t.index ["group_id"], name: "index_packages_on_group_id"
    t.index ["md5"], name: "index_packages_on_md5", unique: true
    t.index ["name", "epoch", "version", "release", "arch"], name: "packages_name_epoch_version_release_arch_index"
    t.index ["name", "epoch", "version", "release", "buildtime", "arch"], name: "packages_name_epoch_version_release_buildtime_arch_index"
    t.index ["name", "epoch", "version", "release", "buildtime"], name: "packages_name_epoch_version_release_buildtime_index"
    t.index ["name", "epoch", "version", "release"], name: "packages_name_epoch_version_release_index"
    t.index ["name"], name: "index_packages_on_name"
    t.index ["src_id"], name: "index_packages_on_src_id"
    t.index ["tsv"], name: "index_packages_on_tsv", using: :gin
    t.index ["type"], name: "index_packages_on_type"
  end

  create_table "patches", id: :serial, force: :cascade do |t|
    t.binary "patch"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "filename", limit: 255
    t.integer "size"
    t.bigint "package_id", comment: "Ссылка на пакет"
    t.index ["package_id"], name: "index_patches_on_package_id"
  end

  create_table "perl_watches", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "version", limit: 255
    t.string "path", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_perl_watches_on_name"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.tsvector "tsv_body"
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
    t.index ["tsv_body"], name: "index_pg_search_documents_on_tsv_body", using: :gin
  end

  create_table "pghero_query_stats", id: :serial, force: :cascade do |t|
    t.text "database"
    t.text "user"
    t.text "query"
    t.bigint "query_hash"
    t.float "total_time"
    t.bigint "calls"
    t.datetime "captured_at"
    t.index ["database", "captured_at"], name: "index_pghero_query_stats_on_database_and_captured_at"
  end

  create_table "provides", id: :serial, force: :cascade do |t|
    t.integer "package_id"
    t.string "name", limit: 255
    t.string "version", limit: 255
    t.string "release", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "flags"
    t.integer "epoch"
    t.index ["package_id"], name: "index_provides_on_package_id"
  end

  create_table "repocop_notes", force: :cascade do |t|
    t.bigint "package_id", null: false, comment: "Ссылка на архитектурный пакет, к которому применима заметка"
    t.integer "status", null: false, comment: "Короткий статус заметки: заметка, ошибка, предупреждение или опыт"
    t.string "kind", null: false, comment: "Короткое описание заметки"
    t.string "description", null: false, comment: "Описание заметки"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_repocop_notes_on_kind"
    t.index ["package_id", "kind"], name: "index_repocop_notes_on_package_id_and_kind", unique: true
    t.index ["package_id"], name: "index_repocop_notes_on_package_id"
    t.index ["status"], name: "index_repocop_notes_on_status"
  end

  create_table "repocop_patches", primary_key: "package_id", force: :cascade do |t|
    t.text "text", null: false, comment: "Текст заплатки"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requires", id: :serial, force: :cascade do |t|
    t.integer "package_id"
    t.string "name", limit: 255
    t.string "version", limit: 255
    t.string "release", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "flags"
    t.integer "epoch"
    t.index ["package_id"], name: "index_requires_on_package_id"
  end

  create_table "rpms", force: :cascade do |t|
    t.string "filename", null: false, comment: "Имя файла srpm, такое, как он представлен в заданной ветви"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "branch_path_id", null: false, comment: "Указатель на путь к ветви, откуда пакет был истянут"
    t.datetime "obsoleted_at", comment: "Время устаревания пакета, если установлено, то пакет более не находится в ветви"
    t.string "name", null: false, comment: "Имя исходного пакета"
    t.bigint "package_id", null: false, comment: "Ссылка на пакет"
    t.index ["branch_path_id", "filename", "package_id", "obsoleted_at"], name: "index_rpms_on_branch_path_id_filename_package_id_obsoleted_at", unique: true
    t.index ["branch_path_id"], name: "index_rpms_on_branch_path_id"
    t.index ["filename"], name: "index_rpms_on_filename"
    t.index ["name"], name: "index_rpms_on_name"
    t.index ["package_id"], name: "index_rpms_on_package_id"
  end

  create_table "sources", id: :serial, force: :cascade do |t|
    t.binary "content"
    t.string "filename", limit: 255
    t.integer "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "source"
    t.bigint "package_id", comment: "Ссылка на пакет"
    t.index ["package_id"], name: "index_sources_on_package_id"
  end

  create_table "specfiles", id: :serial, force: :cascade do |t|
    t.binary "spec"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "package_id", comment: "Ссылка на пакет"
    t.text "text"
    t.tsvector "tsv"
    t.index ["package_id"], name: "index_specfiles_on_package_id"
    t.index ["tsv"], name: "index_specfiles_on_tsv", using: :gin
  end

  create_table "team_people", id: :serial, force: :cascade do |t|
    t.string "person_slug", null: false, comment: "Ссылка на сопровождающего в команде"
    t.string "team_slug", null: false, comment: "Ссылка на сопровождающую команду"
    t.bigint "branch_path_id", null: false, comment: "Ссылка на путь ветви"
    t.index ["branch_path_id"], name: "index_team_people_on_branch_path_id"
    t.index ["person_slug"], name: "index_team_people_on_person_slug"
    t.index ["team_slug", "person_slug", "branch_path_id"], name: "index_team_people_on_three_fields", unique: true
    t.index ["team_slug"], name: "index_team_people_on_team_slug"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.boolean "leader"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "branch_id"
    t.integer "maintainer_id"
    t.index ["branch_id"], name: "index_teams_on_branch_id"
    t.index ["maintainer_id"], name: "index_teams_on_maintainer_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "unconfirmed_email", limit: 255
    t.boolean "admin", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "acls", "branch_paths"
  add_foreign_key "branch_groups", "branches", on_delete: :cascade
  add_foreign_key "branch_groups", "groups", on_delete: :cascade
  add_foreign_key "branch_paths", "branch_paths", column: "source_path_id", on_delete: :cascade
  add_foreign_key "branch_paths", "branches", on_delete: :cascade
  add_foreign_key "changelogs", "maintainers", on_delete: :nullify
  add_foreign_key "changelogs", "packages", column: "spkg_id"
  add_foreign_key "changelogs", "packages", on_delete: :restrict
  add_foreign_key "ftbfs", "branches", on_delete: :cascade
  add_foreign_key "gear_maintainers", "gears", on_delete: :cascade
  add_foreign_key "gear_maintainers", "maintainers", on_delete: :cascade
  add_foreign_key "issue_assignees", "issues", on_delete: :cascade
  add_foreign_key "issues", "branch_paths", on_delete: :cascade
  add_foreign_key "mirrors", "branches", on_delete: :cascade
  add_foreign_key "packages", "groups", on_delete: :restrict
  add_foreign_key "packages", "maintainers", column: "builder_id", on_delete: :restrict
  add_foreign_key "patches", "packages", on_delete: :restrict
  add_foreign_key "repocop_notes", "packages", on_delete: :cascade
  add_foreign_key "repocop_patches", "packages", on_delete: :cascade
  add_foreign_key "rpms", "branch_paths", on_delete: :cascade
  add_foreign_key "rpms", "packages", on_delete: :cascade
  add_foreign_key "sources", "packages", on_delete: :restrict
  add_foreign_key "specfiles", "packages", on_delete: :restrict
  add_foreign_key "team_people", "branch_paths", on_delete: :cascade
  add_foreign_key "teams", "branches", on_delete: :cascade
end
