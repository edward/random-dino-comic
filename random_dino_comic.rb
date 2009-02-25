Shoes.app do
  def random_comic
    @status.text = "Hold on; we’re choosing a random comic..."
    
    download 'http://www.ohnorobot.com/random.pl?comic=23' do |random_comic_page|
      comic_url = "http://www.qwantz.com/" + random_comic_page.response.body[/(comics\/comic.*?png)/]
      
      # debug(File.exists?("recent_comic.png"))
      File.delete("recent_comic.png") if File.exists?("recent_comic.png")
      # debug(File.exists?("recent_comic.png"))
      
      # Weird that recent_comic.png does not get overwritten
      download comic_url, :save => "recent_comic.png",
        :progress => proc { 
          @status.text = "Ok! Pulling it down from the interpipes..."
        },
        :finish => proc {
          @comic_placeholder.clear
          @comic_placeholder.append { image "recent_comic.png" }
          @status.text = comic_url
        }
    end
  end
  
  background "#555"
  
  stack :margin => 10 do
    title strong("Random Dinosaur Comic"), :align => "center", :stroke => "#DFA", :margin => 0
    
    @comic_placeholder = flow :width => 500

    @status = caption "Hold on; we’re choosing a random comic...", :align => "center"
    
    random_comic
    
    button("Yes, I would like another.") { random_comic }
  end
end