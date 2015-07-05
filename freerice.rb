require 'watir-webdriver'
b = Watir::Browser.new
b.goto 'freerice.com'

points = 0
overallCounter = 0
while true do
	sleep(1.0/24.0)
	if b.div(id: 'game-status').div(class: 'block-top').exists?
   		if !b.div(id: 'incorrect').exists?
   			begin
	   			if b.p(id: 'game-status-right').text.split(' ')[4] != 'donation'
	   				begin
	   					points = b.p(id: 'game-status-right').text.split(' ')[4]
	   				rescue
	   					puts "couldn't find game-status-right, continuing"
	   				end
	   				if points.to_i > 100
	   					points = 0
	   					overallCounter += 110
	   					puts overallCounter

	   					b.close
	   					b = Watir::Browser.new
	   					b.goto 'freerice.com'
	   				end
	   			end
	   		rescue
	   			puts "couldn't find game-status-right, continuing"
	   		end
   		end
   	end

   	sleep(1.0/24.0)
   	if b.div(class: 'social-skip-button').exists?
  		begin 
    		b.div(class: 'social-skip-button').fire_event :click
    	rescue
    		puts "couldn't find social-skip-button, continuing"
    	end
 	 else
 	 	begin
    		b.link(class: 'answer-item').click
    	rescue
    		puts "couldn't find an answer to click on, continuing"
    	end
  	end
end