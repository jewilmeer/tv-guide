# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :episode do |f|
  f.title "MyString"
  f.description "MyText"
  f.path "MyString"
  f.filename "MyString"
  f.nr 1
  f.downloaded false
  f.watched ""
  f.season_id 1
end
