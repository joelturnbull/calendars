module AttachmentSettings

  class << self
    def included(base)
      base.extend ClassMethods
    end
  end

  module ClassMethods
    def has_attachment(name, options = {})

      # Examples: "user_avatars" or "asset_uploads" or "message_previews"
      attachment_owner    = self.table_name.singularize
      attachment_folder   = "#{attachment_owner}_#{name.to_s.pluralize}"
      # we want to create a path for the upload that looks like:
      # message_previews/00/11/22/001122deadbeef/thumbnail.png
      attachment_path     = options.delete(:attachment_path)
      attachment_path     ||= "#{attachment_folder}/:filename"

      if Rails.env.production?
        options[:path]            ||= attachment_path
        options[:storage]         ||= :s3
        options[:s3_credentials] = { access_key_id: ENV['AWS_ACCESS_KEY_ID'] }
        options[:s3_credentials] = { secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] }
        options[:s3_credentials] = { bucket: 'music-feeds' }
        options[:s3_headers] = { 'Content-Type'=> "text/calendar", 'Content-Disposition' => 'attachment' }
      else
        options[:storage] ||= :filesystem
        options[:path]  ||= ":rails_root/public/system/attachments/#{Rails.env}/#{attachment_path}"
        options[:url]   ||= "/system/attachments/#{Rails.env}/#{attachment_path}"
      end

      has_attached_file name, options
    end
  end
end

