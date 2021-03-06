# encoding: UTF-8
User.new.tap do |u|
  u.name = "rumble"
  u.email = "rumble@dearfriend.cc"
  u.password = "rumble"
  u.password_confirmation ="rumble"
  u.admin = true
  u.save
end

Project.create([
  { name: "Happy Grandpa Asylum", goal: 150, description: "The Happy Grandpa Asylum is a non-profit institution with the goal of enabling elderly people to have a life with dignity and quality. The services provided by the institution include an environment filled with friendship and harmony, and with specialized personnel to look after the health and nutritional needs of its residents.\n\nThe Happy Grandpa is presently housing 150 permanent residents, amongst men and women. Amongst the residents, 45% has no family ties outside the asylum, being their affective relations daily cultivated with the staff and with voluntary workers.\n\nBeing a part of the Dear Friend project will enable our residents to engage with personal real life stories, filling their time with affection and bonding with other people – even if this is so done by distance. Besides these personal achievements, the Happy Grandpa will be able to gather funding for the improvement of its facilities. The specific goal is to reform their game room, by acquiring new games and furniture.", image: File.open("#{Rails.root}/spec/fixtures/images/asylum-cover.jpg") },
  { name: "We Want to Learn", goal: 150, description: "The ‘We Want to Learn’ group is part of an adult alphabetization program held by the University of Human Xerox, at Happy Harbor. The group’s students are either family members of the University staff or members of the nearby community, ranging in age from 15 up to 50 years old.\n\nThe group has been advised by their teacher to participate in the Dear Friend project so as to seize an amazing opportunity to test their own limits and potentialities. The participation in the project is always going to enable the students to interact with other people and their personal stories as part of their learning process.\n\nThe fifteen students involved in this initiative aim at the transcription of 150 letters in order to form a sort of ‘Letter’s Library’ that will help student’s learning process during classes.", image: File.open("#{Rails.root}/spec/fixtures/images/learn-cover.jpg") },
  { name: "Mary Penny", goal: 50, description: "Dear Friends,\n\nMy name is Mary Penny and I am an eighty-year-old retired calligrapher. It has been twenty years since I was able to find a project to work on. Last week, my granddaughter told me about Dear Friend and I was delighted at the opportunity of getting back to work.\n\nEngaging in this project will give meaning to my remaining days. This is my goal in participating in this amazing initiative.", image: File.open("#{Rails.root}/spec/fixtures/images/mary-penny-cover.jpg") },
  { name: "Happy Harbor Deaf Association", goal: 200, description: "The Happy Harbor Deaf Association promotes a variety of learning and joyous activities for its members, in order to promote social inclusion for the hearing impaired. Many young people from underprivileged communities participate in weekly arts, music, sports and reading activities specially developed by the Association staff.\n\nThe young members involved in the music activities dream with new drums and want to transcript 200 letters so as to transform this dream into reality.", image: File.open("#{Rails.root}/spec/fixtures/images/deaf-cover.jpg") }
])

Setting['facebook.key']     = 'key'
Setting['facebook.secret']  = 'secret'
Setting['twitter.key']      = 'key'
Setting['twitter.secret']   = 'secret'
Setting['mail.smtp']        = "smtp.domain.com"
Setting['mail.port']        = 587
Setting['mail.username']    = "mail@domain.com"
Setting['mail.password']    = "password"
Setting['aws.key']          = "key"
Setting['aws.secret']       = "secret"

