require 'csv'

wednesdays_with_end_prices = Hash.new()
otherdays_with_high_prices = Hash.new()
otherdays_with_low_prices = Hash.new()
week_with_high_low_wave = Hash.new()

period_month = (Date.new(2008,01)..Date.new(2020,02)).select {|d| d.day == 1}
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
		  	high_prices = row[2].delete(',').to_f
		  	low_prices = row[3].delete(',').to_f
		  	if cwday == 3
		  		wednesdays_with_end_prices[date] = end_price
		  	end
		  	otherdays_with_high_prices[date] = high_prices
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
		high_prices = {}
		low_prices = {}
		high_prices[date] = start_prices
		high_prices[date.next_day] = otherdays_with_high_prices[date.next_day]
		high_prices[date.next_day.next_day] = otherdays_with_high_prices[date.next_day.next_day]
		high_prices[date.next_day.next_day.next_day.next_day.next_day] = otherdays_with_high_prices[date.next_day.next_day.next_day.next_day.next_day]
		high_prices[date.next_day.next_day.next_day.next_day.next_day.next_day] = otherdays_with_high_prices[date.next_day.next_day.next_day.next_day.next_day.next_day]
		high_prices[date.next_day.next_day.next_day.next_day.next_day.next_day.next_day] = otherdays_with_high_prices[date.next_day.next_day.next_day.next_day.next_day.next_day.next_day]
		low_prices[date] = start_prices
		low_prices[date.next_day] = otherdays_with_low_prices[date.next_day]
		low_prices[date.next_day.next_day] = otherdays_with_low_prices[date.next_day.next_day]
		low_prices[date.next_day.next_day.next_day.next_day.next_day] = otherdays_with_low_prices[date.next_day.next_day.next_day.next_day.next_day]
		low_prices[date.next_day.next_day.next_day.next_day.next_day.next_day] = otherdays_with_low_prices[date.next_day.next_day.next_day.next_day.next_day.next_day]
		low_prices[date.next_day.next_day.next_day.next_day.next_day.next_day.next_day] = otherdays_with_low_prices[date.next_day.next_day.next_day.next_day.next_day.next_day.next_day]
		high_prices_max = high_prices.values.compact.max
		high_prices_day = high_prices.key(high_prices_max)
		high_wave = high_prices_max - start_prices
		low_prices_min = low_prices.values.compact.min
		low_prices_day = low_prices.key(low_prices_min)
		low_wave = low_prices_min - start_prices
		high_prices_cwday = 0
		low_prices_cwday = 0
		if high_prices_day == date
			high_prices_cwday = 0
			low_prices_cwday = 0
		else
			high_prices_cwday = high_prices_day.cwday
			low_prices_cwday = low_prices_day.cwday
		end
		week_with_high_low_wave[date] = {
			wave: (end_prices -  start_prices).round(2),
			high_prices_cwday: high_prices_cwday, 
			low_prices_cwday: low_prices_cwday,
			high_wave: high_wave,
			low_wave: low_wave
		}
	else
		#puts date
	end
end

waves = []
got_high_prices_waves = []
got_low_prices_waves = []
high_prices_open = 0
high_prices_monday = 0
high_prices_tuesday = 0
high_prices_wednesday = 0
high_prices_thursday = 0
high_prices_friday = 0
low_prices_open = 0
low_prices_monday = 0
low_prices_tuesday = 0
low_prices_wednesday = 0
low_prices_thursday = 0
low_prices_friday = 0
week_with_high_low_wave.each do |k,v|
	waves << v[:wave]
	high_prices_cwday = v[:high_prices_cwday]
	low_prices_cwday = v[:low_prices_cwday]
	case high_prices_cwday
		when 0
			high_prices_open += 1
	 	when 1
	 		high_prices_monday += 1
 		when 2
 			high_prices_tuesday += 1
 		when 3
 			high_prices_wednesday += 1
 		when 4
 			high_prices_thursday += 1
 		when 5 
 			high_prices_friday += 1
	end
	case low_prices_cwday
		when 0
			low_prices_open += 1
	 	when 1
	 		low_prices_monday += 1
 		when 2
 			low_prices_tuesday += 1
 		when 3
 			low_prices_wednesday += 1
 		when 4
 			low_prices_thursday += 1
 		when 5 
 			low_prices_friday += 1
	end
end

wave_level = 570
wave_level_2 = 100
rise_buy_win = 0
rise_sell_win = 0
decline_buy_win = 0
decline_sell_win = 0
buy_win = 0
sell_win = 0
got_high_prices_rise_buy_win = 0
got_high_prices_rise_sell_win = 0
got_low_prices_decline_buy_win = 0
got_low_prices_decline_sell_win = 0

week_with_high_low_wave.each do |k,v|
	if v[:high_wave] >= wave_level_2
		got_high_prices_waves << v[:wave]
	end
end

week_with_high_low_wave.each do |k,v|
	if v[:low_wave] <= -wave_level_2
		got_low_prices_waves << v[:wave]
	end
end

waves.each do |wave|
	if wave >= wave_level
		rise_buy_win += 1
	else
		rise_sell_win += 1
	end
end

waves.each do |wave|
	if wave <= -wave_level
		decline_buy_win += 1
	else
		decline_sell_win += 1
	end
end

waves.each do |wave|
	if wave.abs <= wave_level
		sell_win += 1
	else
		buy_win += 1
	end
end

got_high_prices_waves.each do |wave|
	if wave >= wave_level
		got_high_prices_rise_buy_win += 1
	else
		got_high_prices_rise_sell_win += 1
	end
end

got_low_prices_waves.each do |wave|
	if wave <= -wave_level
		got_low_prices_decline_buy_win += 1
	else
		got_low_prices_decline_sell_win += 1
	end
end

rise_sell_win_rate = (rise_sell_win.to_f/(rise_sell_win.to_f+rise_buy_win.to_f)).round(2)
decline_sell_win_rate = (decline_sell_win.to_f/(decline_sell_win.to_f+decline_buy_win.to_f)).round(2)
sell_win_rate = (sell_win.to_f/(sell_win.to_f+buy_win.to_f)).round(2)
got_high_prices_rise_sell_win_rate = (got_high_prices_rise_sell_win.to_f/(got_high_prices_rise_sell_win.to_f+got_high_prices_rise_buy_win.to_f)).round(2)
got_low_prices_decline_sell_win_rate = (got_low_prices_decline_sell_win.to_f/(got_low_prices_decline_sell_win.to_f+got_low_prices_decline_buy_win.to_f)).round(2)
high_prices_open_rate = (high_prices_open.to_f/(high_prices_open.to_f + high_prices_monday.to_f + high_prices_tuesday.to_f + high_prices_wednesday.to_f + high_prices_thursday.to_f + high_prices_friday.to_f)).round(2)
high_prices_monday_rate = (high_prices_monday.to_f/(high_prices_open.to_f + high_prices_monday.to_f + high_prices_tuesday.to_f + high_prices_wednesday.to_f + high_prices_thursday.to_f + high_prices_friday.to_f)).round(2)
high_prices_tuesday_rate = (high_prices_tuesday.to_f/(high_prices_open.to_f + high_prices_monday.to_f + high_prices_tuesday.to_f + high_prices_wednesday.to_f + high_prices_thursday.to_f + high_prices_friday.to_f)).round(2)
high_prices_wednesday_rate = (high_prices_wednesday.to_f/(high_prices_open.to_f + high_prices_monday.to_f + high_prices_tuesday.to_f + high_prices_wednesday.to_f + high_prices_thursday.to_f + high_prices_friday.to_f)).round(2)
high_prices_thursday_rate = (high_prices_thursday.to_f/(high_prices_open.to_f + high_prices_monday.to_f + high_prices_tuesday.to_f + high_prices_wednesday.to_f + high_prices_thursday.to_f + high_prices_friday.to_f)).round(2)
high_prices_friday_rate = (high_prices_friday.to_f/(high_prices_open.to_f + high_prices_monday.to_f + high_prices_tuesday.to_f + high_prices_wednesday.to_f + high_prices_thursday.to_f + high_prices_friday.to_f)).round(2)

low_prices_open_rate = (low_prices_open.to_f/(low_prices_open.to_f + low_prices_monday.to_f + low_prices_tuesday.to_f + low_prices_wednesday.to_f + low_prices_thursday.to_f + low_prices_friday.to_f)).round(2)
low_prices_monday_rate = (low_prices_monday.to_f/(low_prices_open.to_f + low_prices_monday.to_f + low_prices_tuesday.to_f + low_prices_wednesday.to_f + low_prices_thursday.to_f + low_prices_friday.to_f)).round(2)
low_prices_tuesday_rate = (low_prices_tuesday.to_f/(low_prices_open.to_f + low_prices_monday.to_f + low_prices_tuesday.to_f + low_prices_wednesday.to_f + low_prices_thursday.to_f + low_prices_friday.to_f)).round(2)
low_prices_wednesday_rate = (low_prices_wednesday.to_f/(low_prices_open.to_f + low_prices_monday.to_f + low_prices_tuesday.to_f + low_prices_wednesday.to_f + low_prices_thursday.to_f + low_prices_friday.to_f)).round(2)
low_prices_thursday_rate = (low_prices_thursday.to_f/(low_prices_open.to_f + low_prices_monday.to_f + low_prices_tuesday.to_f + low_prices_wednesday.to_f + low_prices_thursday.to_f + low_prices_friday.to_f)).round(2)
low_prices_friday_rate = (low_prices_friday.to_f/(low_prices_open.to_f + low_prices_monday.to_f + low_prices_tuesday.to_f + low_prices_wednesday.to_f + low_prices_thursday.to_f + low_prices_friday.to_f)).round(2)

puts "=============================="
puts "漲不超過#{wave_level}點機率 ： #{rise_sell_win_rate}"
puts "跌不超過#{wave_level}點機率 ： #{decline_sell_win_rate}"
#puts "漲跌不超過#{wave_level}點擊率 ： #{sell_win_rate}"
puts "=============================="
puts "當發生最高點#{wave_level_2}，最後漲不超過#{wave_level}點機率 ： #{got_high_prices_rise_sell_win_rate}"
puts "當發生最低點#{wave_level_2}，最後跌不超過#{wave_level}點機率 ： #{got_low_prices_decline_sell_win_rate}"
puts "=============================="
puts "最高點發生在開盤天機率 ： #{high_prices_open_rate}"
puts "最高點發生在禮拜四機率 ： #{high_prices_thursday_rate}"
puts "最高點發生在禮拜五機率 ： #{high_prices_friday_rate}"
puts "最高點發生在禮拜一機率 ： #{high_prices_monday_rate}"
puts "最高點發生在禮拜二機率 ： #{high_prices_tuesday_rate}"
puts "最高點發生在結算機率 ： #{high_prices_wednesday_rate}"
puts "=============================="
puts "最低點發生在開盤天機率 ： #{low_prices_open_rate}"
puts "最低點發生在禮拜四機率 ： #{low_prices_thursday_rate}"
puts "最低點發生在禮拜五機率 ： #{low_prices_friday_rate}"
puts "最低點發生在禮拜一機率 ： #{low_prices_monday_rate}"
puts "最低點發生在禮拜二機率 ： #{low_prices_tuesday_rate}"
puts "最低點發生在結算機率 ： #{low_prices_wednesday_rate}"
