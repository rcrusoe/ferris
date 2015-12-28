require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :phone_number => "",
        :name => "Name",
        :email => "Email",
        :neighborhood => "Neighborhood",
        :number_of_conversations => 1,
        :needs_response => ""
      ),
      User.create!(
        :phone_number => "",
        :name => "Name",
        :email => "Email",
        :neighborhood => "Neighborhood",
        :number_of_conversations => 1,
        :needs_response => ""
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Neighborhood".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
