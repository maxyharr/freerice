require 'watir-webdriver'
b = Watir::Browser.new
b.goto 'freerice.com'

#answers = b.links(class: 'answer-item')
#matchPhrase = b.link(class: 'question-link')
#matchWord = matchPhrase.text.split(' ').first

#puts matchWord
#puts answers[0].text
#puts answers[1].text
#puts answers[2].text
#puts answers[3].text

newPoints = 0
oldPoints = 0

while true do
	if b.text.include? 'Correct!'
		begin
			newPoints = b.p(id: 'game-status-right').text.split(' ')[4]
		rescue
			b.close
			b = Watir::Browser.new
		end
	    puts "newPoints: #{newPoints}, \noldPoints: #{oldPoints}\n\n"
	    if newPoints == oldPoints
	    	oldPoints = newPoints
	    	b.refresh
	    else
	    	oldPoints = newPoints
	    end
	end
  # 	if b.div(id: 'game-status').div(class: 'block-top').exists?
  # 		if !b.div(id: 'incorrect').exists?
		#     newPoints = b.p(id: 'game-status-right').text.split(' ')[4]
		#     puts "newPoints: #{newPoints}, \noldPoints: #{oldPoints}\n\n"
		#     if newPoints == oldPoints
		#     	oldPoints = newPoints
		#     	b.refresh
		#     else
		#     	oldPoints = newPoints
		#     end
		# end
  # 	end
 

  	if b.div(class: 'social-skip-button').exists?
  		begin 
    		b.div(class: 'social-skip-button').when_present.fire_event :click
    	rescue
    		b.close
    		b = Watir::Browser.new
    	end
 	 else
    	b.link(class: 'answer-item').when_present.click
  	end

end

b.close
