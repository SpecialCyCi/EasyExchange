# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    name "highschool"
    description ""
    durability do
      rand(1..9)
    end
    price 1.23
    contacter do
      names = %w|张先生 小白 李小姐 鹏哥 小迪 小明 小红|
      names.sample
    end
    contact do
      "18825166388"
    end
    exchangeable do
      rand(0..1)
    end
    want_exchange do
      wants = %w|经济数学 吻一个 交换电话 饭一顿 陪我打游戏|
      wants.sample
    end
    latitude do
      22.45000 + rand(0.000..3.000)
    end
    longitude do
      113.14000 + rand(0.000..3.00)
    end
  end
end
