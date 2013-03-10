require 'spec_helper'

describe "directions/edit" do
  before(:each) do
    @direction = assign(:direction, stub_model(Direction,
      :name => "MyText",
      :position => 1,
      :recipe => nil
    ))
  end

  it "renders the edit direction form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", direction_path(@direction), "post" do
      assert_select "textarea#direction_name[name=?]", "direction[name]"
      assert_select "input#direction_position[name=?]", "direction[position]"
      assert_select "input#direction_recipe[name=?]", "direction[recipe]"
    end
  end
end
