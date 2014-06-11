class Package < ActiveRecord::Base
  belongs_to :architecture
  belongs_to :recipe
end
