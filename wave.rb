require 'csv'

puts "============波動分析============"

mondays_with_end_prices = Hash.new()
tuesdays_with_end_prices = Hash.new()
wednesdays_with_end_prices = Hash.new()
thursdays_with_end_prices = Hash.new()
fridays_with_end_prices = Hash.new()

mondays_with_waves = Hash.new()
tuesdays_with_waves = Hash.new()
wednesdays_with_waves = Hash.new()
thursdays_with_waves = Hash.new()
fridays_with_waves = Hash.new()
#closingday_wave = Hash.new()

period_month = (Date.new(2009,11)..Date.new(2019,11)).select {|d| d.day == 1}
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
		  	case cwday
		  	 	when 1
		  	 		mondays_with_end_prices[date] = end_price
			 		when 2
			 			tuesdays_with_end_prices[date] = end_price
			 		when 3
			 			wednesdays_with_end_prices[date] = end_price
			 		when 4
			 			thursdays_with_end_prices[date] = end_price
			 		when 5 
			 			fridays_with_end_prices[date] = end_price
		  	end
		  rescue Exception => e
		  	# puts e
		  end
		end
	end
end 

mondays = mondays_with_end_prices.keys
tuesdays = tuesdays_with_end_prices.keys
wednesdays = wednesdays_with_end_prices.keys
thursdays = thursdays_with_end_prices.keys
fridays = fridays_with_end_prices.keys

# 禮拜一波動
mondays.each do |date|
	yesterday = date.prev_day.prev_day.prev_day
	if fridays.include? yesterday
		mondays_with_waves[date.strftime("%Y/%m/%d")] = (mondays_with_end_prices[date] - fridays_with_end_prices[yesterday]).round(2)
	end
end

# mondays_with_waves
mondays_waves = mondays_with_waves.values
mondays_positive_waves = mondays_with_waves.values.select { |e| e > 0 }
mondays_negative_waves = mondays_with_waves.values.select { |e| e < 0 }
mondays_waves_sort = mondays_waves.sort
mondays_positive_waves_sort = mondays_positive_waves.sort
mondays_negative_waves_sort = mondays_negative_waves.sort

monday_avg_wave = (mondays_waves.inject(0, :+)/mondays_waves.size).round(2)
monday_avg_positive_wave = (mondays_positive_waves.inject(0, :+)/mondays_positive_waves.size).round(2)
monday_avg_negative_wave = (mondays_negative_waves.inject(0, :+)/mondays_negative_waves.size).round(2)
monday_median_wave = mondays_waves_sort[mondays_waves_sort.size/2]
monday_median_positive_wave = mondays_positive_waves_sort[mondays_positive_waves_sort.size/2]
monday_median_negative_wave = mondays_negative_waves_sort[mondays_negative_waves_sort.size/2]
monday_positive_odds = (mondays_positive_waves.size.to_f/mondays_waves.size.to_f).round(2)
monday_negative_odds = (mondays_negative_waves.size.to_f/mondays_waves.size.to_f).round(2)
monday_max = mondays_waves.max
monday_min = mondays_waves.min

puts "============禮拜一============"
puts "禮拜一波動中位數#{monday_median_wave}點"
puts "禮拜一波動平均數#{monday_avg_wave}點"
puts "禮拜一上漲機率#{monday_positive_odds}"
puts "禮拜一上漲中位數#{monday_median_positive_wave}點"
puts "禮拜一上漲平均數#{monday_avg_positive_wave}點"
puts "禮拜一最大上漲#{monday_max}點"
puts "禮拜一下跌機率#{monday_negative_odds}"
puts "禮拜一下跌中位數#{monday_median_negative_wave}點"
puts "禮拜一下跌平均數#{monday_avg_negative_wave}點"
puts "禮拜一最大下跌#{monday_min}點"

# 禮拜二波動
tuesdays.each do |date|
	yesterday = date.prev_day
	if mondays.include? yesterday
		tuesdays_with_waves[date.strftime("%Y/%m/%d")] = (tuesdays_with_end_prices[date] - mondays_with_end_prices[yesterday]).round(2)
	end
end

# tuesdays_with_waves
tuesdays_waves = tuesdays_with_waves.values
tuesdays_positive_waves = tuesdays_with_waves.values.select { |e| e > 0 }
tuesdays_negative_waves = tuesdays_with_waves.values.select { |e| e < 0 }
tuesdays_waves_sort = tuesdays_waves.sort
tuesdays_positive_waves_sort = tuesdays_positive_waves.sort
tuesdays_negative_waves_sort = tuesdays_negative_waves.sort

tuesday_avg_wave = (tuesdays_waves.inject(0, :+)/tuesdays_waves.size).round(2)
tuesday_avg_positive_wave = (tuesdays_positive_waves.inject(0, :+)/tuesdays_positive_waves.size).round(2)
tuesday_avg_negative_wave = (tuesdays_negative_waves.inject(0, :+)/tuesdays_negative_waves.size).round(2)
tuesday_median_wave = tuesdays_waves_sort[tuesdays_waves_sort.size/2]
tuesday_median_positive_wave = tuesdays_positive_waves_sort[tuesdays_positive_waves_sort.size/2]
tuesday_median_negative_wave = tuesdays_negative_waves_sort[tuesdays_negative_waves_sort.size/2]
tuesday_positive_odds = (tuesdays_positive_waves.size.to_f/tuesdays_waves.size.to_f).round(2)
tuesday_negative_odds = (tuesdays_negative_waves.size.to_f/tuesdays_waves.size.to_f).round(2)
tuesday_max = tuesdays_waves.max
tuesday_min = tuesdays_waves.min

puts "============禮拜二============"
puts "禮拜二波動中位數#{tuesday_median_wave}點"
puts "禮拜二波動平均數#{tuesday_avg_wave}點"
puts "禮拜二上漲機率#{tuesday_positive_odds}"
puts "禮拜二上漲中位數#{tuesday_median_positive_wave}點"
puts "禮拜二上漲平均數#{tuesday_avg_positive_wave}點"
puts "禮拜二最大上漲#{tuesday_max}點"
puts "禮拜二下跌機率#{tuesday_negative_odds}"
puts "禮拜二下跌中位數#{tuesday_median_negative_wave}點"
puts "禮拜二下跌平均數#{tuesday_avg_negative_wave}點"
puts "禮拜二最大下跌#{tuesday_min}點"

# 禮拜三波動
wednesdays.each do |date|
	yesterday = date.prev_day
	if tuesdays.include? yesterday
		wednesdays_with_waves[date.strftime("%Y/%m/%d")] = (wednesdays_with_end_prices[date] - tuesdays_with_end_prices[yesterday]).round(2)
	end
end

# wednesdays_with_waves
wednesdays_waves = wednesdays_with_waves.values
wednesdays_positive_waves = wednesdays_with_waves.values.select { |e| e > 0 }
wednesdays_negative_waves = wednesdays_with_waves.values.select { |e| e < 0 }
wednesdays_waves_sort = wednesdays_waves.sort
wednesdays_positive_waves_sort = wednesdays_positive_waves.sort
wednesdays_negative_waves_sort = wednesdays_negative_waves.sort

wednesday_avg_wave = (wednesdays_waves.inject(0, :+)/wednesdays_waves.size).round(2)
wednesday_avg_positive_wave = (wednesdays_positive_waves.inject(0, :+)/wednesdays_positive_waves.size).round(2)
wednesday_avg_negative_wave = (wednesdays_negative_waves.inject(0, :+)/wednesdays_negative_waves.size).round(2)
wednesday_median_wave = wednesdays_waves_sort[wednesdays_waves_sort.size/2]
wednesday_median_positive_wave = wednesdays_positive_waves_sort[wednesdays_positive_waves_sort.size/2]
wednesday_median_negative_wave = wednesdays_negative_waves_sort[wednesdays_negative_waves_sort.size/2]
wednesday_positive_odds = (wednesdays_positive_waves.size.to_f/wednesdays_waves.size.to_f).round(2)
wednesday_negative_odds = (wednesdays_negative_waves.size.to_f/wednesdays_waves.size.to_f).round(2)
wednesday_max = wednesdays_waves.max
wednesday_min = wednesdays_waves.min

puts "============禮拜三============"
puts "禮拜三波動中位數#{wednesday_median_wave}點"
puts "禮拜三波動平均數#{wednesday_avg_wave}點"
puts "禮拜三上漲機率#{wednesday_positive_odds}"
puts "禮拜三上漲中位數#{wednesday_median_positive_wave}點"
puts "禮拜三上漲平均數#{wednesday_avg_positive_wave}點"
puts "禮拜三最大上漲#{wednesday_max}點"
puts "禮拜三下跌機率#{wednesday_negative_odds}"
puts "禮拜三下跌中位數#{wednesday_median_negative_wave}點"
puts "禮拜三下跌平均數#{wednesday_avg_negative_wave}點"
puts "禮拜三最大下跌#{wednesday_min}點"

# 禮拜四波動
thursdays.each do |date|
	yesterday = date.prev_day
	if wednesdays.include? yesterday
		thursdays_with_waves[date.strftime("%Y/%m/%d")] = (thursdays_with_end_prices[date] - wednesdays_with_end_prices[yesterday]).round(2)
	end
end

# thursdays_with_waves
thursdays_waves = thursdays_with_waves.values
thursdays_positive_waves = thursdays_with_waves.values.select { |e| e > 0 }
thursdays_negative_waves = thursdays_with_waves.values.select { |e| e < 0 }
thursdays_waves_sort = thursdays_waves.sort
thursdays_positive_waves_sort = thursdays_positive_waves.sort
thursdays_negative_waves_sort = thursdays_negative_waves.sort

thursday_avg_wave = (thursdays_waves.inject(0, :+)/thursdays_waves.size).round(2)
thursday_avg_positive_wave = (thursdays_positive_waves.inject(0, :+)/thursdays_positive_waves.size).round(2)
thursday_avg_negative_wave = (thursdays_negative_waves.inject(0, :+)/thursdays_negative_waves.size).round(2)
thursday_median_wave = thursdays_waves_sort[thursdays_waves_sort.size/2]
thursday_median_positive_wave = thursdays_positive_waves_sort[thursdays_positive_waves_sort.size/2]
thursday_median_negative_wave = thursdays_negative_waves_sort[thursdays_negative_waves_sort.size/2]
thursday_positive_odds = (thursdays_positive_waves.size.to_f/thursdays_waves.size.to_f).round(2)
thursday_negative_odds = (thursdays_negative_waves.size.to_f/thursdays_waves.size.to_f).round(2)
thursday_max = thursdays_waves.max
thursday_min = thursdays_waves.min

puts "============禮拜四============"
puts "禮拜四波動中位數#{thursday_median_wave}點"
puts "禮拜四波動平均數#{thursday_avg_wave}點"
puts "禮拜四上漲機率#{thursday_positive_odds}"
puts "禮拜四上漲中位數#{thursday_median_positive_wave}點"
puts "禮拜四上漲平均數#{thursday_avg_positive_wave}點"
puts "禮拜四最大上漲#{thursday_max}點"
puts "禮拜四下跌機率#{thursday_negative_odds}"
puts "禮拜四下跌中位數#{thursday_median_negative_wave}點"
puts "禮拜四下跌平均數#{thursday_avg_negative_wave}點"
puts "禮拜四最大下跌#{thursday_min}點"

# 禮拜五波動
fridays.each do |date|
	yesterday = date.prev_day
	if thursdays.include? yesterday
		fridays_with_waves[date.strftime("%Y/%m/%d")] = (fridays_with_end_prices[date] - thursdays_with_end_prices[yesterday]).round(2)
	end
end

# fridays_with_waves
fridays_waves = fridays_with_waves.values
fridays_positive_waves = fridays_with_waves.values.select { |e| e > 0 }
fridays_negative_waves = fridays_with_waves.values.select { |e| e < 0 }
fridays_waves_sort = fridays_waves.sort
fridays_positive_waves_sort = fridays_positive_waves.sort
fridays_negative_waves_sort = fridays_negative_waves.sort

friday_avg_wave = (fridays_waves.inject(0, :+)/fridays_waves.size).round(2)
friday_avg_positive_wave = (fridays_positive_waves.inject(0, :+)/fridays_positive_waves.size).round(2)
friday_avg_negative_wave = (fridays_negative_waves.inject(0, :+)/fridays_negative_waves.size).round(2)
friday_median_wave = fridays_waves_sort[fridays_waves_sort.size/2]
friday_median_positive_wave = fridays_positive_waves_sort[fridays_positive_waves_sort.size/2]
friday_median_negative_wave = fridays_negative_waves_sort[fridays_negative_waves_sort.size/2]
friday_positive_odds = (fridays_positive_waves.size.to_f/fridays_waves.size.to_f).round(2)
friday_negative_odds = (fridays_negative_waves.size.to_f/fridays_waves.size.to_f).round(2)
friday_max = fridays_waves.max
friday_min = fridays_waves.min

puts "============禮拜五============"
puts "禮拜五波動中位數#{friday_median_wave}點"
puts "禮拜五波動平均數#{friday_avg_wave}點"
puts "禮拜五上漲機率#{friday_positive_odds}"
puts "禮拜五上漲中位數#{friday_median_positive_wave}點"
puts "禮拜五上漲平均數#{friday_avg_positive_wave}點"
puts "禮拜五最大上漲#{friday_max}點"
puts "禮拜五下跌機率#{friday_negative_odds}"
puts "禮拜五下跌中位數#{friday_median_negative_wave}點"
puts "禮拜五下跌平均數#{friday_avg_negative_wave}點"
puts "禮拜五最大下跌#{friday_min}點"


total_positive_odds = ((mondays_positive_waves.size
+ tuesdays_positive_waves.size
+ wednesdays_positive_waves.size
+ thursdays_positive_waves.size
+ fridays_positive_waves.size).to_f/
(mondays_waves.size
+ tuesdays_waves.size
+ wednesdays_waves.size
+ thursdays_waves.size
+ fridays_waves.size
).to_f).round(2)

total_negative_odds = ((mondays_negative_waves.size
+ tuesdays_negative_waves.size
+ wednesdays_negative_waves.size
+ thursdays_negative_waves.size
+ fridays_negative_waves.size).to_f/
(mondays_waves.size
+ tuesdays_waves.size
+ wednesdays_waves.size
+ thursdays_waves.size
+ fridays_waves.size
).to_f).round(2)

total_positive_waves = mondays_positive_waves + tuesdays_positive_waves + wednesdays_positive_waves + thursdays_positive_waves + fridays_positive_waves
total_negative_waves = mondays_negative_waves + tuesdays_negative_waves + wednesdays_negative_waves + thursdays_negative_waves + fridays_negative_waves
total_avg_positive_wave = (total_positive_waves.inject(0, :+)/total_positive_waves.size).round(2)
total_avg_negative_wave = (total_negative_waves.inject(0, :+)/total_negative_waves.size).round(2)

total_positive_waves_sort = total_positive_waves.sort
total_negative_waves_sort = total_negative_waves.sort
total_median_positive_wave = total_positive_waves_sort[total_positive_waves_sort.size/2]
total_median_negative_wave = total_negative_waves_sort[total_negative_waves_sort.size/2]

total_waves = mondays_waves + tuesdays_waves + wednesdays_waves + thursdays_waves + fridays_waves
total_waves_sort = total_waves.sort
total_avg_wave = (total_waves.inject(0, :+)/total_waves.size).round(2)
total_median_wave = total_waves_sort[total_waves_sort.size/2]
total_max = total_waves.max
total_min = total_waves.min

puts "============總計============"
puts "波動中位數#{total_median_wave}點"
puts "波動平均數#{total_avg_wave}點"
puts "上漲機率#{total_positive_odds}"
puts "上漲中位數#{total_median_positive_wave}點"
puts "上漲平均數#{total_avg_positive_wave}點"
puts "最大上漲#{total_max}"
puts "下跌機率#{total_negative_odds}"
puts "下跌中位數#{total_median_negative_wave}點"
puts "下跌平均數#{total_avg_negative_wave}點"
puts "最大下跌#{total_min}"
# continuse days

#wednesday.each do |day| 
#	yesterday = day.prev_day
#	before_yesterday = yesterday.prev_day
#	if ((tuesday.include? yesterday) && (monday.include? before_yesterday))
#		tuesday_wave = (tuesdays_with_end_prices[yesterday] - mondays_with_end_prices[before_yesterday]).round(2)
#		wednesday_wave = (wednesdays_with_end_prices[day] - tuesdays_with_end_prices[yesterday]).round(2)
#		closingday_wave[day.strftime("%Y/%m/%d")] = [tuesday_wave,wednesday_wave]
#	else
		# no_continue_days << day
#	end
#end





