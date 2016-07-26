require 'rails_helper'

RSpec.feature "visitor can view products" do
  scenario "visitor can see product index" do
    product = create(:product)

    visit products_path

    within "#products" do
      expect(page).to have_content(product.name)
      expect(page).to have_content(product.item_names[0])
    end
  end

  scenario "visitor can see product show page" do
    product = create(:product)

    visit products_path

    click_on product.name

    expect(current_path).to eq(product_path(product))

    within "#product" do
      expect(page).to have_content(product.items)
      expect(page).to have_content(product.price)
    end
  end
end