class Recipe < ActiveRecord::Base
  has_many :packages
  has_one :lint
end
