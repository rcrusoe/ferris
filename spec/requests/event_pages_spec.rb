require 'spec_helper'
require 'rails_helper'

describe "Event pages" do

  subject { page }

  describe "create event page" do
    let(:event) { FactoryGirl.create(:event) }
    before { visit new_path }

    it { should have_content('Event') }
    it { should have_title(full_title('Event')) }
  end

  describe "event page" do
  # Replace with code to make a user variable
  before { visit new_path(event) }

  it { should have_content(event.title) }
end
end