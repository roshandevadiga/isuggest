module Isuggest
	module Finder
		def self.included(base)
			base.extend ClassMethods
			base.include InstanceMethods
		end

	end

	module ClassMethods
		def isuggest_seperator
			isuggest_options[:seperator]
		end

		def total_results
			isuggest_options[:total_suggestions].to_i
		end
	end

	module InstanceMethods
		def is_unique?
			column_name = isuggest_columns.first.to_sym
			return !self.class.exists?(column_name => self.send(column_name))
		end

		def suggestions
			me_suggests = []
			radix = 10
			while me_suggests.length < self.class.total_results
				me_suggests = filter_suggestions(me_suggests, radix)
				radix = radix * 10
			end
			return me_suggests
		end

		def filter_suggestions(me_suggests, num)
			column_name = isuggest_columns.first

			#Considering totol_results count is relatively small < 500, doubling it this should reduce the DB hits
			while(me_suggests.length < (self.class.total_results * 2)) do 
			 me_suggests << create_suggestion(self.send(column_name), num) 
			 me_suggests.uniq!
			end

			db_set = self.class.where(["#{column_name} in (#{me_suggests.map{|item| '"'+item+'"'}.join(',')})"]).select(column_name).collect(&:"#{column_name}")
			
			 results = (db_set.length == 0) ? me_suggests : (me_suggests - db_set)
			 #return only the number of results set in configuration
			 return ((results.length > self.class.total_results) ? results[0..(self.class.total_results - 1)] : results)
		end

		def isuggest_columns
			return self.class.isuggest_options[:on]
		end

		def is_email?
			regex = /([\w]+@[\w]+.[\w]+[.\w]*)/i
			self.send(isuggest_columns.first).match(regex).present?
		end

		def create_suggestion(base_value, num)
			if is_email?
				base_value = base_value.split('@')
				return "#{base_value.first}#{self.class.isuggest_seperator}#{rand(num)}@#{base_value.last}"
			else
				return "#{base_value}#{self.class.isuggest_seperator}#{rand(num)}"
			end
		end
	end
end
