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

Station.find_by(identifier: 21).update(photo: "lillylib.jpeg")
Station.find_by(identifier: 24).update(photo: "florencecenter.jpeg")
Station.find_by(identifier: 30).update(photo: "7A7D.jpeg")
Station.find_by(identifier: 25).update(photo: "cooley.jpeg")
Station.find_by(identifier: 33).update(photo: "highschool.jpeg")
Station.find_by(identifier: 20).update(photo: "villagehill.jpeg")
Station.find_by(identifier: 22).update(photo: "ymca.jpeg")
Station.find_by(identifier: 28).update(photo: "amtrak.png")
Station.find_by(identifier: 32).update(photo: "bridge.png")
Station.find_by(identifier: 23).update(photo: "forbes.png")
Station.find_by(identifier: 20).update(photo: "hospital.png")
Station.find_by(identifier: 26).update(photo: "jmg.png")
Station.find_by(identifier: 31).update(photo: "mainstreet.png")


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

# require 'csv'
# csv_text = File.read(Rails.root.join('notes', 'bike-data-test.csv'))
# csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
# csv.each do |row|
#     b = Bike.find_by(identifier: row['identifier'])
#     d = Dock.find_by(identifier: row['dock'])
#     if d
#         b.dock = d
#     end
#     b.save
# end

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

require 'csv'
csv_text = File.read(Rails.root.join('notes', 'rental-data-test.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
    r = Rental.new
    r.user = User.find_by(first_name: row['name'])
    r.bike = Bike.find_by(identifier: row['bike_id'])
    r.start_time = DateTime.parse(row['start_time'])
    r.predicted_end_time = DateTime.parse(row['predicted_end_time'])
    r.actual_end_time = DateTime.parse(row['actual_end_time'])
    r.start_station = row['start_station']
    r.end_station = row['end_station']
    r.is_complete = row['is_complete']
    r.save
end
puts "There are now #{Rental.count} rows in the rental table"
