require 'csv'

datas = Array.new()
date_gap = Hash.new()
date_highestGap = Hash.new()
date_lowestGap = Hash.new()
date_usingday = Hash.new()
date_highestPrice = Hash.new()
date_lowestPrice = Hash.new()

period_month = (Date.new(2012,01)..Date.new(2020,02)).select {|d| d.day == 1}
period_month_csv = period_month.map do |ele|
  "./data/" + ele.strftime("%Y%m") + ".csv"
end

period_month_csv.each do |file|
	if File.file?(file) 
		CSV.foreach(file) do |data|
			begin
				date = Date.strptime(data[0].strip,"%Y/%m/%d").next_year(1911)
				date_highestPrice[date.strftime("%Y/%m/%d")] = data[2].delete(',').to_f
				date_lowestPrice[date.strftime("%Y/%m/%d")] = data[3].delete(',').to_f			
			rescue => exception
				# puts exception
			end
		end
	end
end 

CSV.foreach("option.csv") do |data|
	datas.unshift(data)
end

datas.each_cons(2) do |data,next_data|
	gap = next_data[2].to_f - data[2].to_f
	usingday = Date.parse(next_data[0]).mjd - Date.parse(data[0]).mjd
	date = "#{next_data[1]}(#{next_data[0]})"
	date_gap[date] = gap
	date_usingday[date] = usingday
	rangeDates = ((Date.parse(data[0]).next_day)..Date.parse(next_data[0])).to_a
	date_highestGap[date] = (rangeDates.map { |date| date_highestPrice[date.strftime("%Y/%m/%d")] }.compact << data[2].to_f << next_data[2].to_f).max - data[2].to_f
	date_lowestGap[date] = (rangeDates.map { |date| date_lowestPrice[date.strftime("%Y/%m/%d")] }.compact << data[2].to_f << next_data[2].to_f).min - data[2].to_f
end

midValue = 0.9
gaps = date_gap.values
gapTotalCount = gaps.count
gapUpCount = gaps.select {|gap| gap > 0}.count
gapDownCount = gaps.select {|gap| gap < 0}.count

gapMaxs = date_gap.max_by(3){|k,v| v}
gapMaxs1 = gapMaxs[0]
gapMaxs2 = gapMaxs[1]
gapMaxs3 = gapMaxs[2]
#gapUpTotalValue = gaps.select {|gap| gap > 0}.inject(0, :+)
gapUpMid = gaps.select {|gap| gap > 0}.sort[gapUpCount*midValue]
gapUpTotalMid = gaps.sort[gapTotalCount*midValue]

gapMins = date_gap.min_by(3){|k,v| v}
gapMins1 = gapMins[0]
gapMins2 = gapMins[1]
gapMins3 = gapMins[2]
#gapDownTotalValue = gaps.select {|gap| gap < 0}.inject(0, :+)
gapDownMid = gaps.select {|gap| gap < 0}.sort.reverse[gapDownCount*midValue]
gapDownTotalMid = gaps.sort.reverse[gapTotalCount*midValue]

gapUp4s = gaps.select {|gap| gap > 400 && gap <= 500}
gapUp3s = gaps.select {|gap| gap > 300 && gap <= 400}
gapUp2s = gaps.select {|gap| gap > 200 && gap <= 300}
gapUp1s = gaps.select {|gap| gap > 100 && gap <= 200}
gapUp0s = gaps.select {|gap| gap > 0 && gap <= 100}

gapZero = gaps.select {|gap| gap == 0 }

gapDown0s = gaps.select {|gap| gap < 0 && gap >= -100}
gapDown1s = gaps.select {|gap| gap < -100 && gap >= -200}
gapDown2s = gaps.select {|gap| gap < -200 && gap >= -300}
gapDown3s = gaps.select {|gap| gap < -300 && gap >= -400}
gapDown4s = gaps.select {|gap| gap < -400 && gap >= -500}
gapDown5s = gaps.select {|gap| gap < -500 && gap >= -600}
gapDown6s = gaps.select {|gap| gap < -600 && gap >= -700}
gapDown7s = gaps.select {|gap| gap < -700 && gap >= -800}
gapDown8s = gaps.select {|gap| gap < -800 && gap >= -900}
gapDown9s = gaps.select {|gap| gap < -900 && gap >= -1000}
gapDown10s = gaps.select {|gap| gap < -1000 && gap >= -1100}
gapDown11s = gaps.select {|gap| gap < -1100 && gap >= -1200}
gapDown12s = gaps.select {|gap| gap < -1200 && gap >= -1300}
gapDown13s = gaps.select {|gap| gap < -1300 && gap >= -1400}
gapDown14s = gaps.select {|gap| gap < -1400 && gap >= -1500}
gapDown15s = gaps.select {|gap| gap < -1500 && gap >= -1600}
gapDown16s = gaps.select {|gap| gap < -1600 && gap >= -1700}

sc100WinCount = gapUp0s.count
sc200WinCount = sc100WinCount + gapUp1s.count
sc300WinCount = sc200WinCount + gapUp2s.count
sc400WinCount = sc300WinCount + gapUp3s.count
sc500WinCount = sc400WinCount + gapUp4s.count

allWinCount = gapZero.count

sp100WinCount = gapDown0s.count
sp200WinCount = sp100WinCount + gapDown1s.count
sp300WinCount = sp200WinCount + gapDown2s.count
sp400WinCount = sp300WinCount + gapDown3s.count
sp500WinCount = sp400WinCount + gapDown4s.count
sp600WinCount = sp500WinCount + gapDown5s.count
sp700WinCount = sp600WinCount + gapDown6s.count
sp800WinCount = sp700WinCount + gapDown7s.count
sp900WinCount = sp800WinCount + gapDown8s.count
sp1000WinCount = sp900WinCount + gapDown9s.count
sp1100WinCount = sp1000WinCount + gapDown10s.count
sp1200WinCount = sp1100WinCount + gapDown11s.count
sp1300WinCount = sp1200WinCount + gapDown12s.count
sp1400WinCount = sp1300WinCount + gapDown13s.count
sp1500WinCount = sp1400WinCount + gapDown14s.count
sp1600WinCount = sp1500WinCount + gapDown15s.count
sp1700WinCount = sp1600WinCount + gapDown16s.count

sc100TotalWinRate = (((sc100WinCount.to_f + allWinCount.to_f + gapDownCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sc200TotalWinRate = (((sc200WinCount.to_f + allWinCount.to_f + gapDownCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sc300TotalWinRate = (((sc300WinCount.to_f + allWinCount.to_f + gapDownCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sc400TotalWinRate = (((sc400WinCount.to_f + allWinCount.to_f + gapDownCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sc500TotalWinRate = (((sc500WinCount.to_f + allWinCount.to_f + gapDownCount.to_f)/(gapTotalCount.to_f))*100).round(4)
	# ================== #
sp100TotalWinRate = (((sp100WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp200TotalWinRate = (((sp200WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp300TotalWinRate = (((sp300WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp400TotalWinRate = (((sp400WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp500TotalWinRate = (((sp500WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp600TotalWinRate = (((sp600WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp700TotalWinRate = (((sp700WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp800TotalWinRate = (((sp800WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp900TotalWinRate = (((sp900WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp1000TotalWinRate = (((sp1000WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp1100TotalWinRate = (((sp1100WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp1200TotalWinRate = (((sp1200WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp1300TotalWinRate = (((sp1300WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp1400TotalWinRate = (((sp1400WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp1500TotalWinRate = (((sp1500WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp1600TotalWinRate = (((sp1600WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)
sp1700TotalWinRate = (((sp1700WinCount.to_f + allWinCount.to_f + gapUpCount.to_f)/(gapTotalCount.to_f))*100).round(4)

sc100WinRate = (((sc100WinCount.to_f)/(gapUpCount.to_f))*100).round(4)
sc200WinRate = (((sc200WinCount.to_f)/(gapUpCount.to_f))*100).round(4)
sc300WinRate = (((sc300WinCount.to_f)/(gapUpCount.to_f))*100).round(4)
sc400WinRate = (((sc400WinCount.to_f)/(gapUpCount.to_f))*100).round(4)
sc500WinRate = (((sc500WinCount.to_f)/(gapUpCount.to_f))*100).round(4)
	# ================== #
sp100WinRate = (((sp100WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp200WinRate = (((sp200WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp300WinRate = (((sp300WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp400WinRate = (((sp400WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp500WinRate = (((sp500WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp600WinRate = (((sp600WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp700WinRate = (((sp700WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp800WinRate = (((sp800WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp900WinRate = (((sp900WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp1000WinRate = (((sp1000WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp1100WinRate = (((sp1100WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp1200WinRate = (((sp1200WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp1300WinRate = (((sp1300WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp1400WinRate = (((sp1400WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp1500WinRate = (((sp1500WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp1600WinRate = (((sp1600WinCount.to_f)/(gapDownCount.to_f))*100).round(4)
sp1700WinRate = (((sp1700WinCount.to_f)/(gapDownCount.to_f))*100).round(4)

# highest lowest
highestGaps = date_highestGap.values
lowestGaps = date_lowestGap.values
highestGapMaxs = date_highestGap.max_by(3){|k,v| v}
highestGapMaxs1 = highestGapMaxs[0]
highestGapMaxs2 = highestGapMaxs[1]
highestGapMaxs3 = highestGapMaxs[2]
lowestGapMaxs = date_lowestGap.min_by(3){|k,v| v}
lowestGapMaxs1 = lowestGapMaxs[0]
lowestGapMaxs2 = lowestGapMaxs[1]
lowestGapMaxs3 = lowestGapMaxs[2]

highestGapUp5s = highestGaps.select {|gap| gap >= 500 }
highestGapUp4s = highestGaps.select {|gap| gap >= 400 }
highestGapUp3s = highestGaps.select {|gap| gap >= 300 }
highestGapUp2s = highestGaps.select {|gap| gap >= 200 }
highestGapUp1s = highestGaps.select {|gap| gap >= 100}
highestGapUp0s = highestGaps.select {|gap| gap > 0}

lowestGapDown0s = lowestGaps.select {|gap| gap < 0 }
lowestGapDown1s = lowestGaps.select {|gap| gap <= -100 }
lowestGapDown2s = lowestGaps.select {|gap| gap <= -200 }
lowestGapDown3s = lowestGaps.select {|gap| gap <= -300 }
lowestGapDown4s = lowestGaps.select {|gap| gap <= -400 }
lowestGapDown5s = lowestGaps.select {|gap| gap <= -500 }
lowestGapDown6s = lowestGaps.select {|gap| gap <= -600 }
lowestGapDown7s = lowestGaps.select {|gap| gap <= -700 }
lowestGapDown8s = lowestGaps.select {|gap| gap <= -800 }
lowestGapDown9s = lowestGaps.select {|gap| gap <= -900 }
lowestGapDown10s = lowestGaps.select {|gap| gap <= -1000 }
lowestGapDown11s = lowestGaps.select {|gap| gap <= -1100 }
lowestGapDown12s = lowestGaps.select {|gap| gap <= -1200 }
lowestGapDown13s = lowestGaps.select {|gap| gap <= -1300 }
lowestGapDown14s = lowestGaps.select {|gap| gap <= -1400 }
lowestGapDown15s = lowestGaps.select {|gap| gap <= -1500 }
lowestGapDown16s = lowestGaps.select {|gap| gap <= -1600 }
lowestGapDown17s = lowestGaps.select {|gap| gap <= -1700 }

highestGapUp5Odd = (((highestGapUp5s.count.to_f)/(gapTotalCount.to_f))*100).round(4)
highestGapUp4Odd = (((highestGapUp4s.count.to_f)/(gapTotalCount.to_f))*100).round(4)
highestGapUp3Odd = (((highestGapUp3s.count.to_f)/(gapTotalCount.to_f))*100).round(4)
highestGapUp2Odd = (((highestGapUp2s.count.to_f)/(gapTotalCount.to_f))*100).round(4)
highestGapUp1Odd = (((highestGapUp1s.count.to_f)/(gapTotalCount.to_f))*100).round(4)
highestGapUp0Odd = (((highestGapUp0s.count.to_f)/(gapTotalCount.to_f))*100).round(4)

lowestGapDown0Odd = ((lowestGapDown0s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown1Odd = ((lowestGapDown1s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown2Odd = ((lowestGapDown2s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown3Odd = ((lowestGapDown3s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown4Odd = ((lowestGapDown4s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown5Odd = ((lowestGapDown5s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown6Odd = ((lowestGapDown6s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown7Odd = ((lowestGapDown7s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown8Odd = ((lowestGapDown8s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown9Odd = ((lowestGapDown9s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown10Odd = ((lowestGapDown10s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown11Odd = ((lowestGapDown11s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown12Odd = ((lowestGapDown12s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown13Odd = ((lowestGapDown13s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown14Odd = ((lowestGapDown14s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown15Odd = ((lowestGapDown15s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown16Odd = ((lowestGapDown16s.count.to_f/gapTotalCount.to_f)*100).round(4)
lowestGapDown17Odd = ((lowestGapDown17s.count.to_f/gapTotalCount.to_f)*100).round(4)

# puts 

puts "==================================最大結算=================================="
puts "#{gapMaxs1[0]}發生結算最大漲幅`#{gapMaxs1[1]}`,週期#{date_usingday[gapMaxs1[0]]}天"
puts "#{gapMaxs2[0]}發生結算第二大漲幅`#{gapMaxs2[1]}`,週期#{date_usingday[gapMaxs2[0]]}天"
puts "#{gapMaxs3[0]}發生結算第三大漲幅`#{gapMaxs3[1]}`,週期#{date_usingday[gapMaxs3[0]]}天"
puts "============================================================================"
puts "#{gapMins1[0]}發生結算最大跌幅`#{gapMins1[1]}`,週期#{date_usingday[gapMins1[0]]}天"
puts "#{gapMins2[0]}發生結算第二大跌幅`#{gapMins2[1]}`,週期#{date_usingday[gapMins2[0]]}天"
puts "#{gapMins3[0]}發生結算第三大跌幅`#{gapMins3[1]}`,週期#{date_usingday[gapMins3[0]]}天"
puts "==================================正結算裡=================================="
puts "-> #{midValue*100}%勝率中位數#{gapUpMid} <-"
puts "sc500點勝率#{sc500WinRate}%"
puts "sc400點勝率#{sc400WinRate}%"
puts "sc300點勝率#{sc300WinRate}%"
puts "sc200點勝率#{sc200WinRate}%"
puts "sc100點勝率#{sc100WinRate}%"
puts "==================================負結算裡=================================="
puts "sp100點勝率#{sp100WinRate}%"
puts "sp200點勝率#{sp200WinRate}%"
puts "sp300點勝率#{sp300WinRate}%"
puts "sp400點勝率#{sp400WinRate}%"
puts "sp500點勝率#{sp500WinRate}%"
puts "sp600點勝率#{sp600WinRate}%"
puts "sp700點勝率#{sp700WinRate}%"
puts "sp800點勝率#{sp800WinRate}%"
puts "sp900點勝率#{sp900WinRate}%"
puts "sp1000點勝率#{sp1000WinRate}%"
puts "sp1100點勝率#{sp1100WinRate}%"
puts "sp1200點勝率#{sp1200WinRate}%"
puts "sp1300點勝率#{sp1300WinRate}%"
puts "sp1400點勝率#{sp1400WinRate}%"
puts "sp1500點勝率#{sp1500WinRate}%"
puts "sp1600點勝率#{sp1600WinRate}%"
puts "sp1700點勝率#{sp1700WinRate}%"
puts "-> #{midValue*100}%勝率中位數#{gapDownMid} <-"
puts "==================================所有總合=================================="
puts "-> #{midValue*100}%勝率中位數#{gapUpTotalMid} <-"
puts "sc500點勝率#{sc500TotalWinRate}%"
puts "sc400點勝率#{sc400TotalWinRate}%"
puts "sc300點勝率#{sc300TotalWinRate}%"
puts "sc200點勝率#{sc200TotalWinRate}%"
puts "sc100點勝率#{sc100TotalWinRate}%"
puts "============================================================================"
puts "sp100點勝率#{sp100TotalWinRate}%"
puts "sp200點勝率#{sp200TotalWinRate}%"
puts "sp300點勝率#{sp300TotalWinRate}%"
puts "sp400點勝率#{sp400TotalWinRate}%"
puts "sp500點勝率#{sp500TotalWinRate}%"
puts "sp600點勝率#{sp600TotalWinRate}%"
puts "sp700點勝率#{sp700TotalWinRate}%"
puts "sp800點勝率#{sp800TotalWinRate}%"
puts "sp900點勝率#{sp900TotalWinRate}%"
puts "sp1000點勝率#{sp1000TotalWinRate}%"
puts "sp1100點勝率#{sp1100TotalWinRate}%"
puts "sp1200點勝率#{sp1200TotalWinRate}%"
puts "sp1300點勝率#{sp1300TotalWinRate}%"
puts "sp1400點勝率#{sp1400TotalWinRate}%"
puts "sp1500點勝率#{sp1500TotalWinRate}%"
puts "sp1600點勝率#{sp1600TotalWinRate}%"
puts "sp1700點勝率#{sp1700TotalWinRate}%"
puts "-> #{midValue*100}%勝率中位數#{gapDownTotalMid} <-"
puts "==================================最大波動=================================="
puts "#{highestGapMaxs1[0]}發生中間最大漲幅`#{highestGapMaxs1[1].to_i}`,週期#{date_usingday[highestGapMaxs1[0]]}天"
puts "#{highestGapMaxs2[0]}發生中間第二大漲幅`#{highestGapMaxs2[1].to_i}`,週期#{date_usingday[highestGapMaxs2[0]]}天"
puts "#{highestGapMaxs3[0]}發生中間第三大漲幅`#{highestGapMaxs3[1].to_i}`,週期#{date_usingday[highestGapMaxs3[0]]}天"
puts "============================================================================"
puts "#{lowestGapMaxs1[0]}發生中間最大跌幅`#{lowestGapMaxs1[1].to_i}`,週期#{date_usingday[lowestGapMaxs1[0]]}天"
puts "#{lowestGapMaxs2[0]}發生中間最大跌幅`#{lowestGapMaxs2[1].to_i}`,週期#{date_usingday[lowestGapMaxs2[0]]}天"
puts "#{lowestGapMaxs3[0]}發生中間最大跌幅`#{lowestGapMaxs3[1].to_i}`,週期#{date_usingday[lowestGapMaxs3[0]]}天"
puts "==================================中間波動=================================="
puts "正波動500點機率#{highestGapUp5Odd}%"
puts "正波動400點機率#{highestGapUp4Odd}%"
puts "正波動300點機率#{highestGapUp3Odd}%"
puts "正波動200點機率#{highestGapUp2Odd}%"
puts "正波動100點機率#{highestGapUp1Odd}%"
puts "正波動機率#{highestGapUp0Odd}%"
puts "============================================================================"
puts "負波動機率#{lowestGapDown0Odd}%"
puts "負波動100點機率#{lowestGapDown1Odd}%"
puts "負波動200點機率#{lowestGapDown2Odd}%"
puts "負波動300點機率#{lowestGapDown3Odd}%"
puts "負波動400點機率#{lowestGapDown4Odd}%"
puts "負波動500點機率#{lowestGapDown5Odd}%"
puts "負波動600點機率#{lowestGapDown6Odd}%"
puts "負波動700點機率#{lowestGapDown7Odd}%"
puts "負波動800點機率#{lowestGapDown8Odd}%"
puts "負波動900點機率#{lowestGapDown9Odd}%"
puts "負波動1000點機率#{lowestGapDown10Odd}%"
puts "負波動1100點機率#{lowestGapDown11Odd}%"
puts "負波動1200點機率#{lowestGapDown12Odd}%"
puts "負波動1300點機率#{lowestGapDown13Odd}%"
puts "負波動1400點機率#{lowestGapDown14Odd}%"
puts "負波動1500點機率#{lowestGapDown15Odd}%"
puts "負波動1600點機率#{lowestGapDown16Odd}%"
puts "負波動1700點機率#{lowestGapDown17Odd}%"