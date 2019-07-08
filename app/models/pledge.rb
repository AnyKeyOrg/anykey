class Pledge < ApplicationRecord
  validates_presence_of    :first_name, :last_name, :email,
  validates_uniqueness_of  :email
  validates_format_of      :email, with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  
end
