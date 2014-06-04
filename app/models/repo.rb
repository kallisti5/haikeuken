class Repo < ActiveRecord::Base
  validates_presence_of :name, :message => 'is missing'
  validates_format_of :url, :with => /(http(?:s)?\:\/\/[a-zA-Z0-9\-]+(?:\.[a-zA-Z0-9\-]+)*\.[a-zA-Z]{2,6}(?:\/?|(?:\/[\w\-]+)*)(?:\/?|\/\w+\.[a-zA-Z]{2,4}(?:\?[\w]+\=[\w\-]+)?)?(?:\&[\w]+\=[\w\-]+)*)/i, :on => :create, :message => 'is invalid'
end
