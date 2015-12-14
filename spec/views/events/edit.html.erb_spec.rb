require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :title => "MyString",
      :description => "MyText",
      :address => "MyString",
      :neighborhood => "MyString",
      :website => "MyString",
      :price => 1,
      :purchase_url => "MyString"
    ))
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do

      assert_select "input#event_title[name=?]", "event[title]"

      assert_select "textarea#event_description[name=?]", "event[description]"

      assert_select "input#event_address[name=?]", "event[address]"

      assert_select "input#event_neighborhood[name=?]", "event[neighborhood]"

      assert_select "input#event_website[name=?]", "event[website]"

      assert_select "input#event_price[name=?]", "event[price]"

      assert_select "input#event_purchase_url[name=?]", "event[purchase_url]"
    end
  end
end
