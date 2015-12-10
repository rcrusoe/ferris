require 'spec_helper'
require 'rails_helper'

describe "Event pages" do

  subject { page }

  describe "create event page" do
    before { visit new_path }

    it { should have_content('Event') }
    it { should have_title(full_title('Event')) }
  end
end