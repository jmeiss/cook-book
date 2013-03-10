require 'spec_helper'

describe "directions/new" do
  before(:each) do
    assign(:direction, stub_model(Direction,
      :name => "MyText",
      :position => 1,
      :recipe => nil
    ).as_new_record)
  end

  it "renders new direction form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", directions_path, "post" do
      assert_select "textarea#direction_name[name=?]", "direction[name]"
      assert_select "input#direction_position[name=?]", "direction[position]"
      assert_select "input#direction_recipe[name=?]", "direction[recipe]"
    end
  end
end
