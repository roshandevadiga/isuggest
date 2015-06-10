module Isuggest
	module Finder
		def self.included(base)
			base.extend ClassMethods
			base.send(:include, InstanceMethods)
		end

	end

	module ClassMethods
		def total_results
			isuggest_options[:total_suggestions].to_i
		end
    
	end

	module InstanceMethods
		def is_unique?
			column_name = isuggest_columns.first.to_sym
			return !self.class.exists?(column_name => self.send(column_name))
		end

		def suggestions(with_suffix=nil)
			me_suggests = []
			radix = 10
      @suffix = with_suffix unless with_suffix.nil?
			while me_suggests.length < self.class.total_results
				me_suggests = filter_suggestions(me_suggests, radix)
				radix = radix * 10
			end
			return me_suggests
		end

		def filter_suggestions(me_suggests, num)
			column_name = isuggest_columns.first

			#Considering totol_results count is relatively small < 500, 
			#doubling it should reduce the DB hits
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
			return options[:on]
		end

		def is_email?
			regex = /([\w]+@[\w]+.[\w]+[.\w]*)/i
			self.send(isuggest_columns.first).match(regex).present?
		end

		def options
			self.class.isuggest_options
		end

		def create_suggestion(base_value, num)
			if is_email?
				base_value = base_value.split('@')
				return "#{base_value.first}#{options[:seperator].sample}#{rand(num)}@#{base_value.last}"
      elsif @suffix.present?
        return "#{base_value}#{options[:seperator].sample}#{rand(num)}#{@suffix}"
			else
				return "#{base_value}#{options[:seperator].sample}#{rand(num)}"
			end
		end
	end
end
