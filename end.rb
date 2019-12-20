require 'csv'

puts "============波動分析============"

wednesdays_with_end_prices = Hash.new()
otherdays_with_hight_prices = Hash.new()
otherdays_with_low_prices = Hash.new()
wednesdays_with_hight_low_wave = Hash.new()

period_month = (Date.new(2015,06)..Date.new(2019,11)).select {|d| d.day == 1}
period_month_csv = period_month.map do |ele|
  "./data/" + ele.strftime("%Y%m") + ".csv"
end

period_month_csv.each do |file|
	if File.file?(file) 
		CSV.foreach(file) do |row|
		  row0 = row[0].strip
		  begin
		  	date = Date.strptime(row0,"%Y/%m/%d").next_year(1911)
		  	cwday = date.cwday
		  	end_price = row[4].delete(',').to_f
		  	hight_prices = row[2].delete(',').to_f
		  	low_prices = row[3].delete(',').to_f
		  	if cwday == 3
		  		wednesdays_with_end_prices[date] = end_price
		  	end
		  	otherdays_with_hight_prices[date] = hight_prices
		  	otherdays_with_low_prices[date] = low_prices
		  rescue Exception => e
		  	# puts e
		  end
		end
	end
end 

wednesdays = wednesdays_with_end_prices.keys
wednesdays.each_with_index do |date,index|
	if date.next_day.next_day.next_day.next_day.next_day.next_day.next_day == wednesdays[index + 1]
		start_prices = wednesdays_with_end_prices[date]
		end_prices = wednesdays_with_end_prices[wednesdays[index + 1]]
		hight_prices = []
		low_prices = []
		hight_prices << start_prices
		hight_prices << otherdays_with_hight_prices[date.next_day]
		hight_prices << otherdays_with_hight_prices[date.next_day.next_day]
		hight_prices << otherdays_with_hight_prices[date.next_day.next_day.next_day.next_day.next_day]
		hight_prices << otherdays_with_hight_prices[date.next_day.next_day.next_day.next_day.next_day.next_day]
		hight_prices << otherdays_with_hight_prices[date.next_day.next_day.next_day.next_day.next_day.next_day.next_day]
		low_prices << start_prices
		low_prices << otherdays_with_low_prices[date.next_day]
		low_prices << otherdays_with_low_prices[date.next_day.next_day]
		low_prices << otherdays_with_low_prices[date.next_day.next_day.next_day.next_day.next_day]
		low_prices << otherdays_with_low_prices[date.next_day.next_day.next_day.next_day.next_day.next_day]
		low_prices << otherdays_with_low_prices[date.next_day.next_day.next_day.next_day.next_day.next_day.next_day]
		wednesdays_with_hight_low_wave[date] = {
			wave: (end_prices -  start_prices).round(2),
			hight_prices: (hight_prices.compact.max - start_prices).round(2), 
			low_prices: (low_prices.compact.min - start_prices).round(2) 
		}
	else
		#puts date
	end
end

waves = []
wednesdays_with_hight_low_wave.each do |k,v|
	waves << v[:wave]
end

level = 100
cost = 0
waves.each do |wave|
	if wave == 0
		cost += 0
	else
		if wave >= level || wave <= -level
			if wave.abs - level >= 50
				cost += 50
			else
				cost += wave.abs - level
			end
		else
			cost += 0
		end
	end
end

waves_post = waves.select { |e| e > 0 }

puts (cost/(waves.size)).round(2)
puts waves_post.sort[(waves_post.size)*0.5]

