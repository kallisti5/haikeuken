# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Architecture.create([{ name: 'x86' }, { name: 'x86_64' }, { name: 'x86_gcc2' }, { name: 'arm' }, { name: 'ppc'}])
Repo.create([{ name: 'Haikuports', url: 'http://packages.haiku-os.org/haikuports/master/repo' }])
