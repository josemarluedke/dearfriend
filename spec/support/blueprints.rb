# Encoding: utf-8
require 'machinist/active_record'

# Add your blueprints here.

Authorization.blueprint do
  user {User.make!}
  provider {"facebook"}
  uid {10000}
end

Message.blueprint do
  author { User.make }
  from_address { "Porto Alegre" }
  letter { "Cum augue? Augue pellentesque tristique ac adipiscing ut, montes placerat et, nec tortor mid montes" }
  project { Project.make! }
  to_address { "São Paulo" }
end

Project.blueprint do
  name {  "Lorem placerat dictumst sit magnis " }
  description { "Cum augue? Augue pellentesque tristique ac adipiscing ut, montes placerat et, nec tortor mid montes" }
  image { File.open("#{Rails.root}/spec/fixtures/images/image.jpg") }
  goal { 100 }
end

User.blueprint do
  name {'Josemar Davi Luedke'}
  email {"josemarluedke#{ sn }@gmail.com"}
  password {'josemar'}
  password_confirmation {'josemar'}
end
