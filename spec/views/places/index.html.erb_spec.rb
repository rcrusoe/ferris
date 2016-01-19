require 'rails_helper'

RSpec.describe "places/index", type: :view do
  before(:each) do
    assign(:places, [
      Place.create!(
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
      ),
      Place.create!(
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
      )
    ])
  end

  it "renders a list of places" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Neighborhood".to_s, :count => 2
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
