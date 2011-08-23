require 'rubygems'
require 'minitest/autorun'
require 'json-schema'
require 'json'

SCHEMA_FILE = File.join(File.dirname(File.expand_path(__FILE__)) , 'schema', 'recipe.json')
RECIPES_PATH = File.join(File.dirname(File.expand_path(__FILE__)) , 'recipes')
schema = File.open(SCHEMA_FILE) { |f| JSON.parse(f.read) }

describe 'recipe' do
  Dir["#{RECIPES_PATH}/**/*\.*"].each do |file|
    it "#{file.sub(/(\..*$)/,'').sub(/^#{RECIPES_PATH}/,'')} contains valid json" do

      begin
        question = File.open(file) { |f| JSON.parse(f.read) }['recipe']
        JSON::Validator.validate!(schema, question, :version => :draft3 )
      rescue JSON::Schema::ValidationError => schema_error
         assertion =  false, schema_error.message
      rescue JSON::ParserError => parser_error
         assertion =  false, parser_error.message
      else
         assertion = true
      end

      assert *assertion
    end
  end
end
