# coding: utf-8
module Filter
	def self.get_random(count)
		value = ""

		0.upto(count) do |index|
			rand = rand(3)
			if rand == 1
				value += ('a'..'z').to_a[rand(26)]
			elsif rand == 2
				value += ('A'..'Z').to_a[rand(26)]
			else
				value += ('0'..'9').to_a[rand(10)]
			end
		end

		value
	end

	def self.valid_datas?(dates)
		unless dates.nil?
			if !dates['0'].nil? && dates['0'] != '' && dates['1'] != ''
				true
			else
				false
			end
		else
			false
		end
	end

	def self.get_boolean(val)
		if val.nil?
			'false'
		else
			if val == true || val == 'true'
				'true'
			else
				'false'
			end
		end
	end

	def self.params_in_url(filters, not_init = false, parame = "", fields = [])
		str = ""

		unless filters.nil?
			filters.each_with_index do |filter, index|
				unless not_init
					if index == 0
						str += "" + filter.first.to_s + "=" + filter.last.to_s
					else
						str += "&" + filter.first.to_s + "=" + filter.last.to_s
					end
				else
					if index == 0 && fields.size == 0
						str += "" + parame + "[#{filter.first}]=" + filter.last
					else
						str += "&" + parame + "[#{filter.first}]=" + filter.last
					end
				end
			end
		end

		str
	end

	def self.translit(string)
    replace = {" " => "-", "." => "-", "–" => "-", "," => "-", "?" => "-", "/" => "-", "’" => "", "А"=>"A","а"=>"a","Б"=>"B","б"=>"b","В"=>"V","в"=>"v","Г"=>"G","г"=>"g","Д"=>"D","д"=>"d",
            "Е"=>"Ye","е"=>"e","Ё"=>"Ye","ё"=>"e","Ж"=>"Zh","ж"=>"zh","З"=>"Z","з"=>"z","И"=>"I","и"=>"i",
            "Й"=>"Y","й"=>"y","К"=>"K","к"=>"k","Л"=>"L","л"=>"l","М"=>"M","м"=>"m","Н"=>"N","н"=>"n",
            "О"=>"O","о"=>"o","П"=>"P","п"=>"p","Р"=>"R","р"=>"r","С"=>"S","с"=>"s","Т"=>"T","т"=>"t",
            "У"=>"U","у"=>"u","Ф"=>"F","ф"=>"f","Х"=>"Kh","х"=>"kh","Ц"=>"Ts","ц"=>"ts","Ч"=>"Ch","ч"=>"ch",
            "Ш"=>"Sh","ш"=>"sh","Щ"=>"Shch","щ"=>"shch","Ъ"=>"","ъ"=>"","Ы"=>"Y","ы"=>"y","Ь"=>"","ь"=>"",
            "Э"=>"E","э"=>"e","Ю"=>"Yu","ю"=>"yu","Я"=>"Ya","я"=>"ya","@"=>"y","$"=>"ye"}

   	Filter.strtr(string, replace)
	end

	def self.in_or(values, field, type)
		str = ""
		values.each_with_index do |val, index|
			str += " #{field} = '#{val}' #{index == values.count - 1 ? '' : 'or'} " if type == 'property' && Apartment.property.values.include?(val)
			str += " #{field} = #{val.to_i} #{index == values.count - 1 ? '' : 'or'} " if type == 'int'
		end
		str != "" ? "(" + str + ")" : ""
	end

	def self.clear_nbsp(str)
		unless str.nil?
			str.gsub(/&nbsp;/i, " ").gsub(/&#39;/i, " ").gsub(/&ldquo;/i, " ").gsub(/&rdquo;/i, " ").gsub(/&amp;/i, " ").gsub(/&rsquo;/i, " ").gsub(/&lsquo;/i, " ").gsub(/&#x000a;/i, " ").gsub(/l&#39;/i, " ").gsub(/d&#39;/i, " ")
		else
			str
		end
	end

	def self.get_price_for_payment(amount)
		str = ""
    1.upto(12 - (amount.to_i * 100).to_s.mb_chars.length).each do |i|
      str += "0"
    end
    str + (amount.to_i * 100).to_s
	end

	def self.is_not_robot?(hash_auto_fill, time_auto_fill, time_robot = 3)
		hash_auto_fill == Digest::MD5.hexdigest("for a bot instead of captcha") && (DateTime.parse(DateTime.now.to_s).to_i - DateTime.parse(time_auto_fill).to_i).to_f >= time_robot
	end

	def self.get_double_int(ch)
		if ch < 10
			"0#{ch}"
		else
			ch
		end
	end

	private

		def self.strtr(str, replace_pairs)
	    keys = replace_pairs.map {|a, b| a }
	    values = replace_pairs.map {|a, b| b }
	    str.gsub(
	      /(#{keys.map{|a| Regexp.quote(a) }.join( ')|(' )})/
	      ) { |match| values[keys.index(match)] }
	  end
end