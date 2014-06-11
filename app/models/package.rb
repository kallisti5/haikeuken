class Package < ActiveRecord::Base
  belongs_to :repo
  belongs_to :architecture
  belongs_to :recipe
end
