class User < ApplicationRecord
  
  # Include selected devise modules. Others available are:
  # :confirmable, :lockable, :omniauthable, :registerable abd :timeoutable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable   
         
end
