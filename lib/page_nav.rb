# coding: utf-8
module PageNav
	# берем левое число пачек
	def page_left(page)
		page_left = page - 1
		page_left = 1 if page_left < 1
		page_left
	end

	def page_number_left(page, count_for_page)
		(page - 1) * count_for_page + 1
	end

	# берем правое число пачек
	def page_right(page, page_number_right, count_users)
		page_right = page + 1
		page_right = page if count_users <= page_number_right
		page_right
	end

	def page_number_right(page, count_for_page, count_users)
		page_number_right = page * count_for_page
		page_number_right = count_users if page_number_right > count_users
		page_number_right
	end

	def get_pages_params(page, count_for_page, count_orders)
		@page_number_left = page_number_left(page, count_for_page)
		@page_number_right = page_number_right(page, count_for_page, count_orders)
		@page_left = page_left(page)
		@page_right = page_right(page, @page_number_right, count_orders)
		@last_page = get_last_page(count_orders, count_for_page)
		@get_left_pages = get_left_pages(page)
		@get_right_pages = get_right_pages(page, @last_page)
	end

	def get_last_page(count_orders, count_for_page)
		page = count_orders.to_f / count_for_page.to_f
		if page.to_i.to_f >= page
			page.to_i
		else
			page.to_i + 1
		end
	end

	def get_left_pages(page)
		mas = Array.new
		index = 0
		count = 5

		if page - 1 > 0
			(page - 1).downto 1 do |i|
				if index < count
					mas << i
					index += 1
				else
					break
				end
			end
		end

		mas.reverse
	end

	def get_right_pages(page, last_page)
		mas = Array.new
		index = 0
		count = 5

		if page < last_page
			(page + 1).upto last_page do |i|
				if index < count
					mas << i
					index += 1
				else
					break
				end
			end
		end

		mas
	end
end