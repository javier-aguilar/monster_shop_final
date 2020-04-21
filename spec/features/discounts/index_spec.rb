require 'rails_helper'

RSpec.describe 'Index Discount Page' do
  describe 'As a merchant employee' do
    before do
      megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @discount1 = megan.discounts.create!(code: "50OFF", description: "50% off 10 items or more", discount: 50, number_of_items: 10, active: true)
      @discount2 = megan.discounts.create!(code: "60OFF", description: "60% off 15 items or more", discount: 60, number_of_items: 15, active: true)
      @discount3 = brian.discounts.create!(code: "SUMMER10", description: "10% off 10 items or more", discount: 10, number_of_items: 10, active: true)

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

       visit merchant_discounts_path
    end
    it 'I can see a list of discounts' do
      within(".discount-#{@discount1.id}") do
        expect(page).to have_content("Code: 50OFF")
        expect(page).to have_content("Description: 50% off 10 items or more")
        expect(page).to have_content("Discount: 50%")
        expect(page).to have_content("Number of Items needed: 10")
      end

      within(".discount-#{@discount2.id}") do
        expect(page).to have_content("Code: 60OFF")
        expect(page).to have_content("Description: 60% off 15 items or more")
        expect(page).to have_content("Discount: 60%")
        expect(page).to have_content("Number of Items needed: 15")
      end

      expect(page).to have_no_content("Code: SUMMER10")
      expect(page).to have_no_content("Description: 10% off 10 items or more")
      expect(page).to have_no_content("Discount: 10%")
    end
    it 'I can see a link to add a discount' do
      expect(page).to have_link("Create New Discount", href: "/merchant/discounts/new")
    end
    it 'I can see links to edit discounts' do
      within(".discount-#{@discount1.id}") do
        expect(page).to have_link("Edit", href: "/merchant/discounts/#{@discount1.id}/edit")
      end

      within(".discount-#{@discount2.id}") do
        expect(page).to have_link("Edit", href: "/merchant/discounts/#{@discount2.id}/edit")
      end

      expect(page).to have_no_link("Edit", href: "/merchant/discounts/#{@discount3.id}/edit")
    end
    it 'I can see links to delete discounts' do
      within(".discount-#{@discount1.id}") do
        expect(page).to have_link("Delete", href: "/merchant/discounts/#{@discount1.id}")
      end

      within(".discount-#{@discount2.id}") do
        expect(page).to have_link("Delete", href: "/merchant/discounts/#{@discount2.id}")
      end

      expect(page).to have_no_link("Delete", href: "/merchant/discounts/#{@discount3.id}")
    end
  end
end
