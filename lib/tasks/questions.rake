require 'open-uri'

namespace :questions do

  desc %(
    Import questions from "SOURCE" (file path or url) into "CATEGORY" (optional).
    Use 'rake questions:import SOURCE="/path/to/questions.txt"'
    or 'rake questions:import SOURCE=http://host/questions.txt" CATEGORY="History"'
  ).squish
  task :import => :environment do
    ActiveRecord::Base.transaction do
      question_category = QuestionCategory.find_or_create_by(name: ENV['CATEGORY']) if ENV['CATEGORY']
      open(ENV['SOURCE']).readlines.each do |line|
        question_text, *answer_values = line.rstrip.split('*')
        question = Question.create!(question_category: question_category, text: question_text)
        answer_values.each do |answer_value|
          question.answers.create!(value: answer_value)
        end
      end # readlines
    end # transaction
  end # :improt

end # questions
