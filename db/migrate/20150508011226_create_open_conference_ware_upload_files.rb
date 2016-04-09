class CreateOpenConferenceWareUploadFiles < ActiveRecord::Migration
  def change
    create_table :open_conference_ware_upload_files do |t|
      t.string :fileName
      t.string :path
      t.string :contentType
      t.integer :userId
      t.integer :eventId

      t.timestamps
    end
  end
end
