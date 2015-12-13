require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :title => "Title",
      :description => "MyText",
      :address => "Address",
      :website => "Website",
      :price => 1,
      :purchase_url => "Purchase Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Website/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Purchase Url/)
  end
end
