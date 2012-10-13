class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :name, :volunteer, :image_url
  has_many :authorizations, dependent: :destroy
  has_many :messages_as_author, class_name: "Message", foreign_key: "author_id"
  has_many :messages_as_volunteer, class_name: "Message", foreign_key: "volunteer_id"
  validates :name, presence: true

  def self.new_with_session(params, session)
    super.tap do |user|
      if auth = session[:omniauth]
        user.email = auth.info.email if auth.info.email.present?
        user.name = auth.info.name
        user.image = auth.info.image
        user.authorizations.build(provider: auth.provider, uid: auth.uid)
      end
    end
  end

  def avatar_url(size = 100)
    return image if image.present?
    "http://gravatar.com/avatar/#{Digest::MD5.new.update(email)}.jpg?s=#{size}"
  end

  def volunteer?
    return true if volunteer && verified_volunteer
    false
  end
end


