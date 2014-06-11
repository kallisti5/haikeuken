class Builder < ActiveRecord::Base
  has_many :builds
  has_one :architecture
end
