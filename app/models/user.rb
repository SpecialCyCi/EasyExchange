class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username, type: String
  field :nickname, type: String
  field :password_encrypt, type: String
  field :authentication_token, type: String
  index({ username: 1 }, { unique: true })
  index({ authentication_token: 1 }, { unique: true })
  mount_uploader :avatar, AvatarUploader
  validates_presence_of :username
  validates_presence_of :nickname

  # 登陆
  def self.login(username, password)
    user = User.where(username: username, password_encrypt: User.generate_salt_md5(password)).first
    if user.blank?
      return nil
    else
      user.update_private_token
      return user
    end
  end

  # 注册
  def self.sign_in(username, password)
    if user = self.create(username: username, 
                          password: password, 
                          nickname: username )
      user.update_private_token
      return user
    end
    return false
  end

  def password
    return @password
  end

  def password=(a)
    @password = a
    self.password_encrypt = User.generate_salt_md5(@password)
  end

  def self.generate_salt_md5(_password)
    salt = "asdqwnd12asdjlkjlk"
    content = "#{_password}#{salt}"
    Digest::MD5.hexdigest(content)
  end

  # 更新token
  def update_private_token
    random_key = "#{SecureRandom.hex(10)}:#{self.id}"
    self.update_attribute(:authentication_token, random_key)
  end

end
