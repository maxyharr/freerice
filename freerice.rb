require 'watir-webdriver'
b = Watir::Browser.new

SLEEP_TIME = 1

points = 0
can_accrue = true
memoizer = {}
temp = {}

# read saved dictionary into memoizer
file = File.open('dictionary.txt', "r")
file.readlines.each do |line|
	words = line.split('---')
	memoizer[words[0].chomp] = words[1].chomp
end
file.close

# read in rice counter
fileCounter = File.open("riceDonated.txt", "r")
fileCounter.readlines.each do |line|
	overallCounter = line.to_i
end
overallCounter ||= 0

fileCounter.close
puts "this script has donated #{overallCounter} grains of rice so far, let's keep it up"

# open dictionary for appending
file = File.open("dictionary.txt", "a")
b.goto "http://freerice.com/user/login"
b.text_field(id: 'edit-name_watermark').when_present.fire_event('focus')
b.text_field(id: 'edit-name').when_present.set('mhar7190')
b.text_field(id: 'edit-pass').when_present.set('AU5HYDPx6y')
b.button(id: 'edit-submit').when_present.click
b.goto "http://freerice.com"
sleep SLEEP_TIME*6

while true do
	if b.div(id: 'game-status').div(class: 'block-top').exists?
   		if !b.div(id: 'incorrect').exists?
   			begin
   				# Last answer was correct, store temp in memoizer 
   				# (but only if it's not already in there)
   				
				puts "memoizing " + temp["matchWord"] + " with " + temp["answer"] + "\n\n"

				memoizer[temp["matchWord"].chomp.downcase] = temp["answer"].chomp.downcase
				memoizer[temp["answer"].chomp.downcase] = temp["matchWord"].chomp.downcase

				file.puts temp["matchWord"].chomp.downcase + "---" + temp["answer"].chomp.downcase
				file.puts temp["answer"].chomp.downcase + "---" + temp["matchWord"].chomp.downcase 
   				
   			

	   			if b.p(id: 'game-status-right').text.split(' ')[4] != 'donation'
	   				begin
	   					points = b.p(id: 'game-status-right').text.split(' ')[4]
	   				rescue
	   					puts "couldn't find game-status-right, continuing"
	   				end
	   				
	   				if points.to_i%1000 < 30 && can_accrue
	   					can_accrue = false
	   					overallCounter += 1000
	   					puts overallCounter

	   					# open counting file for writing
						fileCounter = File.open('riceDonated.txt', "w")
	   					fileCounter.puts overallCounter
	   					fileCounter.close
	   				else
	   					can_accrue = true
	   				end
	   			end
	   		rescue
	   			puts "couldn't find game-status-right, continuing"
	   		end
	   	else
	   		temp = {}
	   		begin
	   			incorrect = b.div(id: 'incorrect')
	   			incorrect = incorrect.text.split(' = ')
	   			match = incorrect[0].split(' ')[1]
	   			ans = incorrect[1]

	   			puts "memoizing " + match.chomp + " with " + ans.chomp
	   			memoizer[match.chomp.downcase] = ans.chomp.downcase
	   			memoizer[ans.chomp.downcase] = match.chomp.downcase
	   			file.puts match.chomp.downcase + "---" + ans.chomp.downcase
	   			file.puts ans.chomp.downcase + "---" + match.chomp.downcase
	   		rescue
	   			puts "failed to memoize incorrect answer"
	   		end
   		end
   	end

   	
   	if b.div(class: 'social-skip-button').exists?
  		begin 
    		b.div(class: 'social-skip-button').fire_event :click
    		sleep SLEEP_TIME
    	rescue
    		puts "couldn't find social-skip-button, continuing"
    	end
 	 else
 	 	begin
 	 		answers = b.links(class: 'answer-item')
 	 		matchPhrase = b.link(class: 'question-link')
  	 		matchWord = matchPhrase.text.split(' ').first
  	 		# puts 'matchWord: ' + matchWord

 	 		# if we have the word memoized, click the answer we know is right
 	 		if memoizer[matchWord]
 	 			puts "we found " + matchWord + " matches " + memoizer[matchWord]
 	 			answers.each do |answer|
 	 				if answer.text.chomp.downcase.eql? memoizer[matchWord].chomp.downcase
 	 					puts "Going to click #{answer.text} \n\n"
 	 					answer.click
 	 					sleep SLEEP_TIME
 	 					break;
 	 				end
 	 			end
 	 			answers[0].click
 	 		else
	 	 		
	 	 		temp = {}
	 	 		temp["answer"] = answers[0].text.chomp
	 	 		temp["matchWord"] = matchWord.chomp
	
	 	 		answers[0].click
	 	 		sleep SLEEP_TIME
 	 		end
    	rescue
    		puts "an error occured while selecting an answer, continuing"
    	end
  	end
end