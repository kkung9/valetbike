# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Station.create!([{
#   identifier: 21,
#   name: "Florence Bank Station",
#   address: "19 Meadow Street Florence MA @ Lilly Library"
# }])

# p "Created station"

Station.destroy_all

require 'csv'
csv_text = File.read(Rails.root.join('notes', 'station-data.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
    s = Station.new
    s.identifier = row['identifier']
    s.name = row['name']
    s.address = row['address']
    s.save
    puts "#{s.name} saved"
end
puts "There are now #{Station.count} rows in the stations table"

Bike.destroy_all

require 'csv'
csv_text = File.read(Rails.root.join('notes', 'bike-data.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
    b = Bike.new
    b.identifier = row['identifier']
    b.current_station_id = row['current_station_identifier']
    s = Station.find_by(identifier: b.current_station_id)
    b.current_station = s
    b.save
    puts "#{b.identifier} saved"
end
puts "There are now #{Bike.count} rows in the bikes table"
