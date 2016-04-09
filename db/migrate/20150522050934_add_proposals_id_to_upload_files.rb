class AddProposalsIdToUploadFiles < ActiveRecord::Migration
  def change
    add_column :open_conference_ware_upload_files, :proposalsId, :integer
  end
end
