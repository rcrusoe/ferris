require 'rails_helper'

RSpec.describe "places/edit", type: :view do
  before(:each) do
    @place = assign(:place, Place.create!(
      :name => "MyString",
      :description => "MyText",
      :address => "MyString",
      :neighborhood => "MyString",
      :website => "MyString",
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

  it "renders the edit place form" do
    render

    assert_select "form[action=?][method=?]", place_path(@place), "post" do

      assert_select "input#place_name[name=?]", "place[name]"

      assert_select "textarea#place_description[name=?]", "place[description]"

      assert_select "input#place_address[name=?]", "place[address]"

      assert_select "input#place_neighborhood[name=?]", "place[neighborhood]"

      assert_select "input#place_website[name=?]", "place[website]"

      assert_select "input#place_phone_number[name=?]", "place[phone_number]"

      assert_select "input#place_monday_open[name=?]", "place[monday_open]"

      assert_select "input#place_tuesday_open[name=?]", "place[tuesday_open]"

      assert_select "input#place_wednesday_open[name=?]", "place[wednesday_open]"

      assert_select "input#place_thursday_open[name=?]", "place[thursday_open]"

      assert_select "input#place_friday_open[name=?]", "place[friday_open]"

      assert_select "input#place_saturday_open[name=?]", "place[saturday_open]"

      assert_select "input#place_sunday_open[name=?]", "place[sunday_open]"
    end
  end
end
