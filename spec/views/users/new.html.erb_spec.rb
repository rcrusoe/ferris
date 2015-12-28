require 'rails_helper'

RSpec.describe "users/new", type: :view do
  before(:each) do
    assign(:user, User.new(
      :phone_number => "",
      :name => "MyString",
      :email => "MyString",
      :neighborhood => "MyString",
      :number_of_conversations => 1,
      :needs_response => ""
    ))
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do

      assert_select "input#user_phone_number[name=?]", "user[phone_number]"

      assert_select "input#user_name[name=?]", "user[name]"

      assert_select "input#user_email[name=?]", "user[email]"

      assert_select "input#user_neighborhood[name=?]", "user[neighborhood]"

      assert_select "input#user_number_of_conversations[name=?]", "user[number_of_conversations]"

      assert_select "input#user_needs_response[name=?]", "user[needs_response]"
    end
  end
end
