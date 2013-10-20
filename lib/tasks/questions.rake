require 'open-uri'

namespace :questions do

  desc %(
    Import questions
    from "SOURCE" (local path or URL),
    separated by "SEPARATOR"
    into "CATEGORY" (optional)
    for "LOCALE".

    Use
      rake questions:import SOURCE="http://host/questions.txt" LOCALE="en" CATEGORY="History"
  ).squish
  task :import => :environment do
    separator = ENV['SEPARATOR'] || '*'
    ActiveRecord::Base.transaction do
      question_category = QuestionCategory.find_or_create_by(name: ENV['CATEGORY']) if ENV['CATEGORY']
      open(ENV['SOURCE']).readlines.each do |line|
        question_text, *answer_values = line.rstrip.split(separator)
        begin
          question = Question.create!(locale: ENV['LOCALE'],
                                      question_category: question_category,
                                      text: question_text)
          answer_values.each do |answer_value|
            question.answers.create!(value: answer_value)
          end
        rescue
        end
      end # readlines
    end # transaction
  end # task

end # questions
