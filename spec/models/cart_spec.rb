require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 2 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @discount1 = @megan.discounts.create!(code: "50OFF", description: "50% off 5 items or more", discount: 50, number_of_items: 5, active: true)
      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end
    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end
    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 1
        })
    end
    it '.count' do
      expect(@cart.count).to eq(3)
    end
    it '.items' do
      expect(@cart.items).to eq([@ogre, @giant])
    end
    it '.grand_total' do
      expect(@cart.grand_total).to eq(120)
    end
    it '.count_of()' do
      expect(@cart.count_of(@ogre.id)).to eq(1)
      expect(@cart.count_of(@giant.id)).to eq(2)
    end
    it '.subtotal_of()' do
      expect(@cart.subtotal_of(@ogre.id)).to eq(20)
      expect(@cart.subtotal_of(@giant.id)).to eq(100)
      4.times do
        @cart.add_item(@ogre.id.to_s)
      end
      expect(@cart.subtotal_of(@ogre.id)).to eq(50)
    end
    it '.limit_reached?()' do
      expect(@cart.limit_reached?(@ogre.id)).to eq(false)
      expect(@cart.limit_reached?(@giant.id)).to eq(true)
    end
    it '.less_item()' do
      @cart.less_item(@giant.id.to_s)

      expect(@cart.count_of(@giant.id)).to eq(1)
    end
    it '.apply_discount()' do
      expect(@cart.apply_discount(@ogre)).to eq(20)
      4.times do
        @cart.add_item(@ogre.id.to_s)
      end
      expect(@cart.apply_discount(@ogre)).to eq(50)
    end
    it '.min_num_of_items?()' do
      expect(@cart.min_num_of_items?(@ogre)).to eq(false)
      4.times do
        @cart.add_item(@ogre.id.to_s)
      end
      expect(@cart.min_num_of_items?(@ogre)).to eq(true)
    end
    it '.discount()' do
      expect(@cart.discount(@ogre)).to eq(nil)
      4.times do
        @cart.add_item(@ogre.id.to_s)
      end
      expect(@cart.discount(@ogre).discount).to eq(50)
    end
    it '.discount_price()' do
      4.times do
        @cart.add_item(@ogre.id.to_s)
      end
      expect(@cart.discount_price(@ogre)).to eq(10)
    end
    it '.display_discount()' do
      4.times do
        @cart.add_item(@ogre.id.to_s)
      end
      expect(@cart.display_discount(@ogre)).to eq("Discount '#{@discount1.code}' has been applied")
    end
  end
end
