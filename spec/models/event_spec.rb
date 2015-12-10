require 'rails_helper'

RSpec.describe Event, type: :model do
  before { @event = Event.new(title: "Example Event", description: "This is an example description.") }

  subject { @event }

  it { should respond_to(:title) }
  it { should respond_to(:description) }

  it { should be_valid }

  describe "when title is not present" do
    before { @event.title = " " }
    it { should_not be_valid }

  describe "when description is not present" do
    before { @event.description = " " }
    it { should_not be_valid }
end
