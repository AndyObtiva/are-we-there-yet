migrate_dir = File.expand_path('../migrate', __FILE__)
Dir.glob(File.join(migrate_dir, '**', '*.rb')).each {|migration| require migration}

ActiveRecord::Migration[5.2].descendants.each do |migration| 
  begin
    migration.migrate(:up)
  rescue => e
    raise e unless e.full_message.match(/table "[^"]+" already exists/)
  end
end
