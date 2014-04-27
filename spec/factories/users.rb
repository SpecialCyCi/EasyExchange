# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username, 10000) do |n|
      "special#{n}"
    end
    nickname do
      nicknames = %w|东京的天空下起了樱花 你的微笑犹如晴天 青柠@ 2逼儿童欢乐多 只有放弃，没有忘记 浅笑こ半度微凉 給糖就不闹 失怹 吐煙圈oοО 地球老子捏圆滴 說愛太烫嘴丷 逝水流年ソ染轻尘 丑到灵魂深处 时光静好↘彼此安好 童心ジ未泯つ △嫣然ァ 岁月划破的伤疤叫成长 萌呆呆グ 真情无需拿来显摆√ 妖孽范儿 把心掐死算了 向钱看向厚赚 众爱卿平身 对着作业唱算你狠、虫児灰(⊙o⊙) 安夏。一哄二闹三撒娇 裸奔的超人 騎豬迲萢妞 哪有骚年不犯二 泪、沾湿衣襟§ 亡命天涯 因为喜欢，所以情愿 命中从不缺狗 拜你所赐 傻里傻气傻孩子 刘厂长 待到菊花烂漫时 菊花朵朵开 射你一脸当面膜 正在节食的吃货 丑角 失心 開始懂ㄋ 亡心 谁也不是谁的谁 安于心 莈死就別把自己當成废物 错觉 兔纸先森 胡闹，其实是一种依赖 誓言=逝言 坚强的背后 让时间说真话 年少不懂爱 到头来只是梦一场 心病没药医 魂牵梦回把心 挖出来喂狗算了|
      nicknames.sample
    end
    avatar do
      File.open Rails.root.join("db", "seeds_data", "avatars", "#{rand(1..40)}.jpg")
    end
    password "testing"
  end
end
