require 'spec_helper'

describe "directions/show" do
  before(:each) do
    @direction = assign(:direction, stub_model(Direction,
      :name => "MyText",
      :position => 1,
      :recipe => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/1/)
    rendered.should match(//)
  end
end
