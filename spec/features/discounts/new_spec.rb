require 'rails_helper'

RSpec.describe 'New Discount Creation' do
  describe 'As a merchant employee' do
    before do
      megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

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
    it 'I can visit /discounts/new to fill out a form to create a new discount' do

      visit new_merchant_discount_path

      fill_in "discount[code]", with: "50OFF"
      fill_in "discount[description]", with: "50% off 10 items or more"
      fill_in "discount[discount]", with: "50"
      fill_in "discount[number_of_items]", with: "10"
      select "True"

      click_button "Create Discount"

      expect(current_path).to eq(merchant_discounts_path)

      discount = Discount.all.last
      within(".discount-#{discount.id}") do
        expect(page).to have_content("Code: 50OFF")
        expect(page).to have_content("Description: 50% off 10 items or more")
        expect(page).to have_content("Discount: 50%")
        expect(page).to have_content("Number of Items needed: 10")
      end

    end
    it 'I can visit /discounts/new to fill out a form to create a new discount
        However, if I do not fill out all information, I will get an error' do

      visit new_merchant_discount_path

      fill_in "discount[code]", with: ""
      fill_in "discount[description]", with: ""
      fill_in "discount[discount]", with: ""
      fill_in "discount[number_of_items]", with: ""
      select ""

      click_button "Create Discount"

      expect(page).to have_content("Code can't be blank")
      expect(page).to have_content("Description can't be blank")
      expect(page).to have_content("Discount is not a number")
      expect(page).to have_content("Number of items can't be blank")
      expect(page).to have_content("Active can't be blank")
    end
    it 'I can visit /discounts/new to fill out a form to create a new discount
        However, if I fill in a number in discount field not between 1-100, I will get an error' do
      visit new_merchant_discount_path

      fill_in "discount[discount]", with: "0"

      click_button "Create Discount"

      expect(page).to have_content("Discount must be greater than or equal to 1")

      fill_in "discount[discount]", with: "9999"

      click_button "Create Discount"

      expect(page).to have_content("Discount must be less than or equal to 100")
    end
  end
end
