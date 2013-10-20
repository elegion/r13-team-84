# encoding: utf-8
locale = 'en'

question = Question.create locale: locale, text: 'How many rings on the Olympic flag?'
Answer.create question: question, value: 'Five'
Answer.create question: question, value: '5'

question = Question.create locale: locale, text: 'What colour is vermilion a shade of?'
Answer.create question: question, value: 'Red'

question = Question.create locale: locale, text: 'King Zog ruled which country'
Answer.create question: question, value: 'Albania'

question = Question.create locale: locale, text: 'What colour is Spock\'s blood?'
Answer.create question: question, value: 'Green'

question = Question.create locale: locale, text: 'Where in your body is your patella?'
Answer.create question: question, value: 'Knee'

question = Question.create locale: locale, text: 'Where can you find London bridge today?'
Answer.create question: question, value: 'USA'
Answer.create question: question, value: 'Unated States of America'

question = Question.create locale: locale, text: 'What spirit is mixed with ginger beer in a Moscow mule'
Answer.create question: question, value: 'Vodka'

question = Question.create locale: locale, text: 'Who was the first man in space?'
Answer.create question: question, value: 'Yuri Gagarin'
Answer.create question: question, value: 'Yury Gagarin'

question = Question.create locale: locale, text: 'On television what was Flipper'
Answer.create question: question, value: 'Dolphin'

question = Question.create locale: locale, text: 'Whose nose grew when he told a lie?'
Answer.create question: question, value: 'Pinocchio'

question = Question.create locale: locale, text: 'Which company is owned by Bill Gates?'
Answer.create question: question, value: 'Microsoft'


locale = 'ru'

question = Question.create locale: locale, text: 'Сколько было колец всевластия во Властелине Колец?'
Answer.create question: question, value: 'одно'
Answer.create question: question, value: '1'

question = Question.create locale: locale, text: 'Зимой и летом одним цветом'
Answer.create question: question, value: 'ель'
Answer.create question: question, value: 'елка'
Answer.create question: question, value: 'ёлка'

question = Question.create locale: locale, text: 'Какого цвета кровь Спока?'
Answer.create question: question, value: 'зелёная'
Answer.create question: question, value: 'зелёный'
Answer.create question: question, value: 'зелёного'

question = Question.create locale: locale, text: 'Какая операционная система в телефонах Apple?'
Answer.create question: question, value: 'iOS'
