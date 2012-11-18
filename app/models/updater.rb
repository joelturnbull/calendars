class Updater
  def self.update(source)
    Event.delete_all
    source.fetch
    Location.write_files
  end
end
