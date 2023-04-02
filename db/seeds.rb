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
Dock.destroy_all
Bike.destroy_all
Station.destroy_all
User.destroy_all

require 'csv'
csv_text = File.read(Rails.root.join('notes', 'station-data-test.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
    s = Station.new
    s.identifier = row['identifier']
    s.name = row['name']
    s.address = row['address']
    s.capacity = row['capacity']
    s.lat = row['lat']
    s.long = row['long']
    s.save
end
puts "There are now #{Station.count} rows in the stations table"

require 'csv'
csv_text = File.read(Rails.root.join('notes', 'bike-data-test.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
    b = Bike.new
    b.identifier = row['identifier']
    b.save
end
puts "There are now #{Bike.count} rows in the bikes table"

require 'csv'
csv_text = File.read(Rails.root.join('notes', 'dock-data-test.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
    d = Dock.new
    d.identifier = row['identifier']
    s = row['station']
    d.station = Station.find_by(identifier: s)
    b = row['bike']
    d.bike = Bike.find_by(identifier: b)
    d.save
end
puts "There are now #{Dock.count} rows in the dock table"

require 'csv'
csv_text = File.read(Rails.root.join('notes', 'bike-data-test.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
    b = Bike.find_by(identifier: row['identifier'])
    d = Dock.find_by(identifier: row['dock'])
    if d
        b.dock_id = d.id
    end
    b.save
end

require 'csv'
csv_text = File.read(Rails.root.join('notes', 'user-data-test.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
    u = User.new
    u.identifier = row['identifier']
    u.first_name = row['first_name']
    u.last_name = row['last_name']
    u.email = row['email']
    u.save
end
puts "There are now #{User.count} rows in the user table"
