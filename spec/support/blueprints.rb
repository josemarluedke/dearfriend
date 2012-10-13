# Encoding: utf-8
require 'machinist/active_record'

# Add your blueprints here.

User.blueprint do
  name {'Josemar Davi Luedke'}
  email {'josemarluedke@gmail.com'}
  password {'josemar'}
  password_confirmation {'josemar'}
end

Authorization.blueprint do
  user {User.make!}
  provider {"facebook"}
  uid {10000}
end

Project.blueprint do
  name {  "Lorem placerat dictumst sit magnis " }
  description { "Cum augue? Augue pellentesque tristique ac adipiscing ut, montes placerat et, nec tortor mid montes" }
  goal { 100 }
end

Message.blueprint do
  letter { "Cum augue? Augue pellentesque tristique ac adipiscing ut, montes placerat et, nec tortor mid montes" }
  author { User.make }
  from_address { "Porto Alegre" }
  to_address { "São Paulo" }
end
