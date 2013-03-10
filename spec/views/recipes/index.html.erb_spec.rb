require 'spec_helper'

describe "recipes/index" do
  before(:each) do
    assign(:recipes, [
      stub_model(Recipe,
        :name => "Name",
        :preparation_time => 1,
        :roasting_time => 2,
        :quantity => "Quantity",
        :url => "MyText",
        :user => nil
      ),
      stub_model(Recipe,
        :name => "Name",
        :preparation_time => 1,
        :roasting_time => 2,
        :quantity => "Quantity",
        :url => "MyText",
        :user => nil
      )
    ])
  end

  it "renders a list of recipes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Quantity".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
