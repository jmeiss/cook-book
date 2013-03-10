require 'spec_helper'

describe "recipes/new" do
  before(:each) do
    assign(:recipe, stub_model(Recipe,
      :name => "MyString",
      :preparation_time => 1,
      :roasting_time => 1,
      :quantity => "MyString",
      :url => "MyText",
      :user => nil
    ).as_new_record)
  end

  it "renders new recipe form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", recipes_path, "post" do
      assert_select "input#recipe_name[name=?]", "recipe[name]"
      assert_select "input#recipe_preparation_time[name=?]", "recipe[preparation_time]"
      assert_select "input#recipe_roasting_time[name=?]", "recipe[roasting_time]"
      assert_select "input#recipe_quantity[name=?]", "recipe[quantity]"
      assert_select "textarea#recipe_url[name=?]", "recipe[url]"
      assert_select "input#recipe_user[name=?]", "recipe[user]"
    end
  end
end
