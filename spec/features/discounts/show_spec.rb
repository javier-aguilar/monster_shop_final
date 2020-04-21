require 'rails_helper'

RSpec.describe 'Show Discount Page' do
  describe 'As a merchant employee' do
    before do
      megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @discount = megan.discounts.create!(code: "50OFF", description: "50% off 10 items or more", discount: 50, number_of_items: 10, active: true)

      employee = User.create(name: "Mike Dao",
           address: "1765 Larimer St",
           city: "Denver",
           state: "CO",
           zip: "80202",
           email: "merchant@example.com",
           password: "password_merchant",
           password_confirmation: "password_merchant",
           role: 1,
           merchant_id: megan.id)
           visit "/login"

       fill_in :email, with: employee.email
       fill_in :password, with: "password_merchant"

       click_button "Log In"
    end
    it 'I can visit /discounts/:id to see discount information' do

      visit "/merchant/discounts/#{@discount.id}"

      within(".discount-#{@discount.id}") do
        expect(page).to have_content("Code: 50OFF")
        expect(page).to have_content("Description: 50% off 10 items or more")
        expect(page).to have_content("Discount: 50%")
        expect(page).to have_content("Number of Items needed: 10")
      end

    end
  end
end
