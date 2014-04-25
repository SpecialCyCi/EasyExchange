# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :good, :class => 'Goods' do
    name "highschool"
    description ""
    durbility 9
    price 1.23
  end
end
