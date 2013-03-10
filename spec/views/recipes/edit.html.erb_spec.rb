require 'spec_helper'

describe "recipes/edit" do
  before(:each) do
    @recipe = assign(:recipe, stub_model(Recipe,
      :name => "MyString",
      :preparation_time => 1,
      :roasting_time => 1,
      :quantity => "MyString",
      :url => "MyText",
      :user => nil
    ))
  end

  it "renders the edit recipe form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", recipe_path(@recipe), "post" do
      assert_select "input#recipe_name[name=?]", "recipe[name]"
      assert_select "input#recipe_preparation_time[name=?]", "recipe[preparation_time]"
      assert_select "input#recipe_roasting_time[name=?]", "recipe[roasting_time]"
      assert_select "input#recipe_quantity[name=?]", "recipe[quantity]"
      assert_select "textarea#recipe_url[name=?]", "recipe[url]"
      assert_select "input#recipe_user[name=?]", "recipe[user]"
    end
  end
end
