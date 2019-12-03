require 'csv'

puts "============選擇權分析============"

weekday_one_with_price = Hash.new()
weekday_two_with_price = Hash.new()
weekday_three_with_price = Hash.new()

wave = Hash.new()

period_month = (Date.new(2019,1)..Date.new(2019,12)).select {|d| d.day == 1}
period_month_csv = period_month.map do |ele|
  ele.strftime("%Y%m") + ".csv"
end

period_month_csv.each do |file|
	if File.file?(file) 
		CSV.foreach(file) do |row|
		  row0 = row[0]
		  begin
		  	date = Date.strptime(row0,"%Y/%m/%d").next_year(1911)
		  	cwday = date.cwday
		  	final_price = row[4].delete(',').to_f
		  	case cwday
		  	 	when 1
		  	 		weekday_one_with_price[date] = final_price
			 		when 2
			 			weekday_two_with_price[date] = final_price
			 		when 3
			 			weekday_three_with_price[date] = final_price
		  	end
		  rescue Exception => e
		  	# puts e
		  end
		end
	end
end 

weekday_one = weekday_one_with_price.keys
weekday_two = weekday_two_with_price.keys
weekday_three = weekday_three_with_price.keys

weekday_three.each do |day| 
	yesterday = day.prev_day
	before_yesterday = yesterday.prev_day
	if ((weekday_two.include? yesterday) && (weekday_one.include? before_yesterday))
		weekday_two_wave = (weekday_two_with_price[yesterday] - weekday_one_with_price[before_yesterday]).round(2)
		weekday_three_wave = (weekday_three_with_price[day] - weekday_two_with_price[yesterday]).round(2)
		wave[day.strftime("%Y/%m/%d")] = [weekday_two_wave,weekday_three_wave]
	else
		puts day
	end
end

p wave


