require "isuggest/version"
require "isuggest/finder"

module Isuggest
   def suggest_me(options={})
   	class_attribute :isuggest_options
  	raise ArgumentError, "Hash expected, got #{options.class.name}" if !options.empty? && !options.is_a?(Hash) 
  	raise ArgumentError, 'No column provides' if options[:on].blank?
  	raise ArgumentError, 'No column provides' if options[:on].present? && !options[:on].is_a?(Array)
  	self.isuggest_options = {total_suggestions: 5, seperator: '' }
  	self.isuggest_options.merge!(options)
  	include Isuggest::Finder
  end
	  	
  ActiveRecord::Base.send :extend, Isuggest
end
