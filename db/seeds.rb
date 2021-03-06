# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Merchants
megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

# Items
megan.items.create!(name: 'Cranberrry', description: "Cranberry Marmalade", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 20 )
megan.items.create!(name: 'Orange', description: "Orange Marmalade", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 40)
brian.items.create!(name: 'Everything Bagel', description: "Delicious!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 30 )

# Users
User.create(name: "Bob",
           address: "123 Stang Ave",
           city: "Hershey",
           state: "PA",
           zip: "17033",
           email: "user@example.com",
           password: "password_regular",
           password_confirmation: "password_regular",
           role: 0)
User.create(name: "Mike Dao",
           address: "1765 Larimer St",
           city: "Denver",
           state: "CO",
           zip: "80202",
           email: "merchant@example.com",
           password: "password_merchant",
           password_confirmation: "password_merchant",
           role: 1,
           merchant_id: megan.id)
User.create(name: "The Boss",
            address: "1765 Larimer St",
            city: "Denver",
            state: "CO",
            zip: "80202",
            email: "admin@example.com",
            password: "password_admin",
            password_confirmation: "password_admin",
            role: 2)

# Discounts
megan.discounts.create!(code: "50OFF", description: "50% off 10 items or more", discount: 50, number_of_items: 10, active: true)
megan.discounts.create!(code: "60OFF", description: "60% off 15 items or more", discount: 60, number_of_items: 15, active: true)
brian.discounts.create!(code: "SUMMER10", description: "10% off 10 items or more", discount: 10, number_of_items: 10, active: true)
