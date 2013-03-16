FactoryGirl.define do
  
  factory :user do
    sequence(:first_name) { |n| "first name #{n}" }
    sequence(:last_name)  { |n| "last name #{n}" }
    sequence(:email)      { |n| "username#{n}@example.com" }
    password 'password'
    password_confirmation { |u| u.password }

    factory :user_with_recipes do
      ignore do
        recipes_count 3
      end

      after :create do |user, evaluator|
        FactoryGirl.create_list :recipe, evaluator.recipes_count, user: user
      end
    end
  end

  factory :recipe do
    sequence(:name)   { |n| "Recipe name #{n}" }
    preparation_time  10
    roasting_time     30
    quantity          "4 persons"
    sequence(:url)    { |n| "http://www.recipes.com/id=#{n}" }
    user

    factory :recipe_with_ingredients do
      ignore do
        ingredients_count 10
      end

      after :create do |recipe, evaluator|
        FactoryGirl.create_list :ingredient, evaluator.ingredients_count, recipe: recipe
      end
    end

    factory :recipe_with_directions do
      ignore do
        directions_count 5
      end

      after :create do |recipe, evaluator|
        FactoryGirl.create_list :direction, evaluator.directions_count, recipe: recipe
      end
    end
  end

  factory :ingredient do
    sequence(:name) { |n| "Ingredient name #{n}" }
    recipe
  end

  factory :direction do
    sequence(:name) { |n| "Direction name #{n}" }
    position        rand(10)
    recipe
  end

end
