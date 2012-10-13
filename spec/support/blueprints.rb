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
