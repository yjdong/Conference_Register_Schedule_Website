require_dependency "open_conference_ware/application_controller"
require 'fileutils'

module OpenConferenceWare
  class UploadFilesController < ApplicationController
      def index
       @data = UploadFile.where(:proposalsId => params[:proposal])
      end

      def create
        uploadFile = params[:uploadFile]
        proposalId = uploadFile[:proposal]
        uploadFile['file'].each do |file|
          fileName, path ,contentType = save_file(file)
          @uploadFile = UploadFile.create(fileName:fileName,contentType:contentType, proposalsId:proposalId, path:path)
          @uploadFile.save
        end
        redirect_to(:back)
      end
      
      def download
          file = UploadFile.find(params[:id])
          send_file file.path,
          :filename => file.fileName,
          :type => file.contentType,
          :disposition => 'attachment'
      end

      def delete
        file = UploadFile.find(params[:id])
        if FileTest::exist?(file.path)
           FileUtils.rm_f(file.path)
        end
        respond_to do |format|
          if file.destroy
            format.js
          end
        end
      end
      
      private
      # return fileName, path
      def save_file(uploadFile)
          name =  uploadFile.original_filename
          contentType = uploadFile.content_type
          directory = "public/uploadFiles/1"

          # check if the directory exists, if not, create it
          unless File.exists?(directory)
            FileUtils::mkdir_p directory
          end

          # create the file path
          path = File.join(directory, name)
          
          # check whether the file existed, if true do rename
          flag = FileTest::exist?(path)
          if flag
              count = 1
              newName = ""
              while(flag)
                  newName =  count.to_s + "_" + name
                  path = File.join(directory,newName)
                  flag = FileTest::exist?(path)
                  count += 1
              end
              name = newName
          end


          # write the file
          File.open(path, "wb") { |f| f.write(uploadFile.read) }
          
          return name, path, contentType
      end
  end
end
