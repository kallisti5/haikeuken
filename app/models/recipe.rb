class Recipe < ActiveRecord::Base
  has_many :packages
  has_many :architectures, through: :packages
  has_many :builds
end
