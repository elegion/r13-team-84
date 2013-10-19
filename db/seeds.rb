# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
question = Question.create text: 'How many rings on the Olympic flag?'
Answer.create question: question, value: 'Five'
Answer.create question: question, value: '5'

question = Question.create text: 'What colour is vermilion a shade of?'
Answer.create question: question, value: 'Red'

question = Question.create text: 'King Zog ruled which country'
Answer.create question: question, value: 'Albania'

question = Question.create text: 'What colour is Spock\'s blood?'
Answer.create question: question, value: 'Green'

question = Question.create text: 'Where in your body is your patella?'
Answer.create question: question, value: 'Knee'

question = Question.create text: 'Where can you find London bridge today?'
Answer.create question: question, value: 'USA'
Answer.create question: question, value: 'Unated States of America'

question = Question.create text: 'What spirit is mixed with ginger beer in a Moscow mule'
Answer.create question: question, value: 'Vodka'

question = Question.create text: 'Who was the first man in space?'
Answer.create question: question, value: 'Yuri Gagarin'
Answer.create question: question, value: 'Yury Gagarin'

question = Question.create text: 'On television what was Flipper'
Answer.create question: question, value: 'Dolphin'

question = Question.create text: 'Whose nose grew when he told a lie?'
Answer.create question: question, value: 'Pinocchio'

question = Question.create text: 'Which company is owned by Bill Gates?'
Answer.create question: question, value: 'Microsoft'
