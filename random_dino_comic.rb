Shoes.app do
  background "#555"
  
  stack :margin => 10 do
    title strong("Random Dinosaur Comic"), :align => "center", :stroke => "#DFA", :margin => 0
    
    @comic_placeholder = flow :width => 500 do
      @temp_comic = image "unicorn.jpg", :width => 50, :height => 50,  :align => "center"
    end

    @status = caption "Hold on; we’re choosing a random comic...", :align => "center"
    
    download 'http://www.ohnorobot.com/random.pl?comic=23' do |random_comic_page|
      comic_url = "http://www.qwantz.com/" + random_comic_page.response.body[/(comics\/comic.*?png)/]
      
      download comic_url, :save => File.basename("recent_comic.png"),
        :progress => proc { 
          @status.text = "Ok! Pulling it down from the interpipes..."
          @temp_comic.top += (-20..20).rand
          @temp_comic.left += (-20..20).rand
        },
        :finish => proc {
          @comic_placeholder.clear
          @comic_placeholder.append { image "recent_comic.png" }
          @status.text = comic_url
        }
    end
  end
end