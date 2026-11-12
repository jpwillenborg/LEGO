service = RebrickableService.new

# Seed in reverse display order so 42207-1 has the newest created_at timestamp and loads first!
["21063-1", "10309-1", "42207-1"].each do |set_num|
  next if LegoSet.exists?(set_num: set_num)

  puts "Caching LEGO set #{set_num}..."
  service.fetch_set(set_num)
end

# Stamp a fresh database epoch token only if one doesn't exist yet
epoch_file = Rails.root.join("tmp/db_epoch.txt")
File.write(epoch_file, Time.current.to_f.to_s) unless File.exist?(epoch_file)

puts "Showcase sandbox sets seeded successfully!"
