class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :first_name, :last_name, presence: true
end
