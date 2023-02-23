class Verification < ApplicationRecord
  has_one_attached :photo_id
  has_one_attached :doctors_note
end
