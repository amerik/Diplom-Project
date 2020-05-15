# coding: utf-8
class ApplicationDecorator < Draper::Decorator

  include ActionView::Helpers::NumberHelper

  private

    def size_file(size)
      number_to_currency(size.to_f, :unit => '', :precision => 2, delimiter: " ")
    end

  	def field_string(value, delimetr = '-')
	    if value.nil? || value == ""
	      delimetr
	    else
	      value
	    end
	  end

	  def field_int(value, delimetr = '-')
	    if value.to_i == 0
	      delimetr
	    else
	      value.to_i
	    end
	  end

    def field_float(value, delimetr = '-')
      if value.to_f == 0
        delimetr
      else
        value.to_f
      end
    end

    def field_percent(value, delimetr = '-')
      if value.to_i == 0
        delimetr
      else
        "#{value.to_i}%"
      end
    end

	  def field_currency(value, delimetr = '-')
	  	"£" + field_int(value, delimetr).to_s
	  end

    def field_currency_round(value, delimetr = '-')
      if value.to_f > value.to_i + 0.5
        field_currency(value.to_i + 1, delimetr)
      else
        field_currency(value.to_i, delimetr)
      end
    end

    def field_currency_float(value, delimetr = '-')
      "£" + field_float(value, delimetr).to_s
    end

    def field_currency_br(value, delimetr = '-')
      "€" + field_int(value, delimetr).to_s
    end

	  def date_at(value, delimetr = '-')
      unless value.nil?
        value.strftime('%d.%m.%Y')
      else
        delimetr
      end
    end

    def datetime_at(value, delimetr = '-')
      unless value.nil?
        value.strftime('%d.%m.%Y, %H:%M')
      else
        delimetr
      end
    end

    def time_at(value, delimetr = '-')
      unless value.nil?
        value.strftime('%H:%M')
      else
        delimetr
      end
    end

    def get_url_name(value)
      if value.nil? || value == ""
        "-"
      else
        value.slice!("http://")
        value.slice!("https://")
        value
      end
    end

    def get_url_url(value)
      if value.nil? || value == ""
        "/"
      else
        if value.include?("http://") || value.include?("https://")
          value
        else
          "http://#{value}"
        end
      end
    end

    # 89269675681 => 8 (926) 967-5681
    # 79269675681 => +7 (926) 967-5681
    # 9675681 => 967-5681
    def field_phone(phone, country = nil)
      # if !phone.nil? && phone != ""
      #   if phone.length > 7
      #     (phone[0, 1] == "7" ? "+" : "") + "#{phone[0, 1]} (#{phone[1, 3]}) #{phone[4, 3]} - #{phone[7, phone.length - 7]}"
      #   else
      #     "#{phone[0, 3]} - #{phone[3, phone.length - 3]}"
      #   end
      # else
      #   "-"
      # end
      field_string(phone) + "#{country.nil? ? '' : ' ('+country.name_en+')'}"
    end
end
