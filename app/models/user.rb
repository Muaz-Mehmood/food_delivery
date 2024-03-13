class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :cart_items
  has_many :orders
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: [:customer, :admin]

  has_one_attached :image

end
