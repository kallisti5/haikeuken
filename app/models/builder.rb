class Builder < ActiveRecord::Base
  has_many :builds
  belongs_to :architecture
end
