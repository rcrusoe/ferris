require 'rails_helper'

RSpec.describe "places/show", type: :view do
  before(:each) do
    @place = assign(:place, Place.create!(
      :name => "Name",
      :description => "MyText",
      :address => "Address",
      :neighborhood => "Neighborhood",
      :website => "Website",
      :phone_number => 1,
      :monday_open => false,
      :tuesday_open => false,
      :wednesday_open => false,
      :thursday_open => false,
      :friday_open => false,
      :saturday_open => false,
      :sunday_open => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Neighborhood/)
    expect(rendered).to match(/Website/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
