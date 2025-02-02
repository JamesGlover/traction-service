# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_06_23_104146) do
  create_table "container_materials", charset: "utf8mb3", force: :cascade do |t|
    t.string "container_type", null: false
    t.bigint "container_id", null: false
    t.string "material_type"
    t.bigint "material_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["container_type", "container_id"], name: "index_container_materials_on_container_type_and_container_id"
    t.index ["material_type", "material_id"], name: "index_container_materials_on_material_type_and_material_id"
  end

  create_table "data_types", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.integer "pipeline", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipeline", "name"], name: "index_data_types_on_pipeline_and_name", unique: true
    t.index ["pipeline"], name: "index_data_types_on_pipeline"
  end

  create_table "flipper_features", charset: "utf8mb3", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", charset: "utf8mb3", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "heron_ont_requests", charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ont_library_id"
    t.string "name"
    t.string "external_id"
    t.string "uuid"
    t.index ["ont_library_id"], name: "index_heron_ont_requests_on_ont_library_id"
  end

  create_table "library_types", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.integer "pipeline", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_identifier"
    t.boolean "active", default: true, null: false
    t.index ["name"], name: "index_library_types_on_name", unique: true
    t.index ["pipeline"], name: "index_library_types_on_pipeline"
  end

  create_table "ont_flowcells", charset: "utf8mb3", force: :cascade do |t|
    t.integer "position"
    t.string "uuid"
    t.bigint "ont_run_id"
    t.bigint "ont_library_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ont_library_id"], name: "index_ont_flowcells_on_ont_library_id"
    t.index ["ont_run_id"], name: "index_ont_flowcells_on_ont_run_id"
    t.index ["position", "ont_run_id"], name: "index_ont_flowcells_on_position_and_ont_run_id", unique: true
  end

  create_table "ont_libraries", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.integer "pool"
    t.integer "pool_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ont_libraries_on_name", unique: true
  end

  create_table "ont_requests", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "library_type_id", null: false
    t.bigint "data_type_id", null: false
    t.integer "number_of_flowcells", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_study_id", limit: 36, null: false
    t.string "cost_code", null: false
    t.index ["data_type_id"], name: "index_ont_requests_on_data_type_id"
    t.index ["library_type_id"], name: "index_ont_requests_on_library_type_id"
  end

  create_table "ont_runs", charset: "utf8mb3", force: :cascade do |t|
    t.integer "state", default: 0
    t.datetime "deactivated_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pacbio_libraries", charset: "utf8mb3", force: :cascade do |t|
    t.float "volume"
    t.float "concentration"
    t.string "template_prep_kit_box_barcode"
    t.integer "insert_size"
    t.string "uuid"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "state"
    t.datetime "deactivated_at", precision: nil
    t.bigint "pacbio_request_id", null: false
    t.bigint "tag_id"
    t.bigint "pacbio_pool_id", null: false
    t.index ["pacbio_pool_id"], name: "index_pacbio_libraries_on_pacbio_pool_id"
    t.index ["pacbio_request_id"], name: "index_pacbio_libraries_on_pacbio_request_id"
    t.index ["tag_id"], name: "index_pacbio_libraries_on_tag_id"
  end

  create_table "pacbio_plates", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "pacbio_run_id"
    t.string "uuid"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["pacbio_run_id"], name: "index_pacbio_plates_on_pacbio_run_id"
  end

  create_table "pacbio_pools", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "tube_id", null: false
    t.float "volume"
    t.float "concentration"
    t.string "template_prep_kit_box_barcode"
    t.integer "insert_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["tube_id"], name: "index_pacbio_pools_on_tube_id"
  end

  create_table "pacbio_request_libraries", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "pacbio_request_id"
    t.bigint "pacbio_library_id"
    t.bigint "tag_id"
    t.index ["pacbio_library_id"], name: "index_pacbio_request_libraries_on_pacbio_library_id"
    t.index ["pacbio_request_id", "pacbio_library_id"], name: "index_rl_request_library", unique: true
    t.index ["pacbio_request_id"], name: "index_pacbio_request_libraries_on_pacbio_request_id"
    t.index ["tag_id", "pacbio_library_id"], name: "index_rl_tag_library", unique: true
    t.index ["tag_id"], name: "index_pacbio_request_libraries_on_tag_id"
  end

  create_table "pacbio_requests", charset: "utf8mb3", force: :cascade do |t|
    t.string "library_type"
    t.integer "estimate_of_gb_required"
    t.integer "number_of_smrt_cells"
    t.string "cost_code"
    t.string "external_study_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "source_barcode"
  end

  create_table "pacbio_runs", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "sequencing_kit_box_barcode"
    t.string "dna_control_complex_box_barcode"
    t.string "comments"
    t.string "uuid"
    t.integer "system_name", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "state", default: 0
    t.datetime "deactivated_at", precision: nil
    t.index ["name"], name: "index_pacbio_runs_on_name", unique: true
  end

  create_table "pacbio_well_libraries", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "pacbio_well_id"
    t.bigint "pacbio_library_id"
    t.index ["pacbio_library_id"], name: "index_pacbio_well_libraries_on_pacbio_library_id"
    t.index ["pacbio_well_id"], name: "index_pacbio_well_libraries_on_pacbio_well_id"
  end

  create_table "pacbio_well_pools", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "pacbio_well_id"
    t.bigint "pacbio_pool_id"
    t.index ["pacbio_pool_id"], name: "index_pacbio_well_pools_on_pacbio_pool_id"
    t.index ["pacbio_well_id"], name: "index_pacbio_well_pools_on_pacbio_well_id"
  end

  create_table "pacbio_wells", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "pacbio_plate_id"
    t.string "row"
    t.string "column"
    t.decimal "movie_time", precision: 3, scale: 1
    t.float "on_plate_loading_concentration"
    t.string "comment"
    t.string "uuid"
    t.integer "sequencing_mode"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "pre_extension_time"
    t.integer "generate_hifi"
    t.string "ccs_analysis_output"
    t.string "binding_kit_box_barcode"
    t.decimal "loading_target_p1_plus_p2", precision: 3, scale: 2
    t.index ["pacbio_plate_id"], name: "index_pacbio_wells_on_pacbio_plate_id"
  end

  create_table "plates", charset: "utf8mb3", force: :cascade do |t|
    t.string "barcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["barcode"], name: "index_plates_on_barcode", unique: true
  end

  create_table "receptions", charset: "utf8mb3", force: :cascade do |t|
    t.string "source", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "sample_id"
    t.string "requestable_type"
    t.bigint "requestable_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "reception_id"
    t.index ["reception_id"], name: "index_requests_on_reception_id"
    t.index ["requestable_type", "requestable_id"], name: "index_requests_on_requestable_type_and_requestable_id"
    t.index ["sample_id"], name: "index_requests_on_sample_id"
  end

  create_table "samples", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "deactivated_at", precision: nil
    t.string "external_id"
    t.string "species"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["external_id"], name: "index_samples_on_external_id", unique: true
    t.index ["name", "external_id", "species"], name: "index_samples_on_name_and_external_id_and_species"
    t.index ["name"], name: "index_samples_on_name", unique: true
  end

  create_table "saphyr_chips", charset: "utf8mb3", force: :cascade do |t|
    t.string "barcode"
    t.string "serial_number"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "saphyr_run_id"
    t.index ["saphyr_run_id"], name: "index_saphyr_chips_on_saphyr_run_id"
  end

  create_table "saphyr_enzymes", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_saphyr_enzymes_on_name", unique: true
  end

  create_table "saphyr_flowcells", charset: "utf8mb3", force: :cascade do |t|
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "saphyr_chip_id"
    t.bigint "saphyr_library_id"
    t.index ["saphyr_chip_id"], name: "index_saphyr_flowcells_on_saphyr_chip_id"
    t.index ["saphyr_library_id"], name: "index_saphyr_flowcells_on_saphyr_library_id"
  end

  create_table "saphyr_libraries", charset: "utf8mb3", force: :cascade do |t|
    t.string "state"
    t.datetime "deactivated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "saphyr_enzyme_id"
    t.bigint "saphyr_request_id"
    t.index ["saphyr_enzyme_id"], name: "index_saphyr_libraries_on_saphyr_enzyme_id"
    t.index ["saphyr_request_id"], name: "index_saphyr_libraries_on_saphyr_request_id"
  end

  create_table "saphyr_requests", charset: "utf8mb3", force: :cascade do |t|
    t.string "external_study_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "saphyr_runs", charset: "utf8mb3", force: :cascade do |t|
    t.integer "state", default: 0
    t.string "name"
    t.datetime "deactivated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "tag_sets", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "uuid"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "pipeline", null: false
    t.integer "sample_sheet_behaviour", default: 0, null: false
  end

  create_table "tag_taggables", charset: "utf8mb3", force: :cascade do |t|
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_tag_taggables_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_tag_taggables_on_taggable_type_and_taggable_id"
  end

  create_table "tags", charset: "utf8mb3", force: :cascade do |t|
    t.string "oligo"
    t.string "group_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "tag_set_id"
    t.index ["group_id", "tag_set_id"], name: "index_tags_on_group_id_and_tag_set_id", unique: true
    t.index ["oligo", "tag_set_id"], name: "index_tags_on_oligo_and_tag_set_id", unique: true
    t.index ["tag_set_id"], name: "index_tags_on_tag_set_id"
  end

  create_table "tubes", charset: "utf8mb3", force: :cascade do |t|
    t.string "barcode"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["barcode"], name: "index_tubes_on_barcode", unique: true
  end

  create_table "wells", charset: "utf8mb3", force: :cascade do |t|
    t.string "position"
    t.bigint "plate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plate_id", "position"], name: "index_wells_on_plate_id_and_position", unique: true
    t.index ["plate_id"], name: "index_wells_on_plate_id"
  end

  add_foreign_key "ont_requests", "data_types"
  add_foreign_key "ont_requests", "library_types"
  add_foreign_key "pacbio_libraries", "pacbio_pools"
  add_foreign_key "pacbio_libraries", "pacbio_requests"
  add_foreign_key "pacbio_pools", "tubes"
  add_foreign_key "requests", "receptions"
end
