require 'spec_helper'

describe "directions/index" do
  before(:each) do
    assign(:directions, [
      stub_model(Direction,
        :name => "MyText",
        :position => 1,
        :recipe => nil
      ),
      stub_model(Direction,
        :name => "MyText",
        :position => 1,
        :recipe => nil
      )
    ])
  end

  it "renders a list of directions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
