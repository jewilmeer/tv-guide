# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :page do |f|
  f.title "MyString"
  f.permalink "MyString"
  f.content "MyText"
  f.user_id 1
end
