Shoes.app :width => 755, :height => 550 do
  @comic_count = 0
  
  def random_comic
    @status.text = "Hold on; we’re choosing a random comic..."
    
    download 'http://www.ohnorobot.com/random.pl?comic=23' do |random_comic_page|
      png_path = random_comic_page.response.body[/(comics\/comic.*?png)/]
      if png_path
        comic_url = "http://www.qwantz.com/" + png_path
      
        # Ridiculous hack around image caching
        Dir.glob("recent*.png").each { |f| File.delete(f) }
        @comic_path = "recent-comic-#{@comic_count}.png"
        @comic_count += 1
      
        download comic_url, :save => @comic_path,
          :progress => proc {
            @status.text = "Ok! Pulling it down from the interpipes..."
          },
          :finish => proc {
            @comic_placeholder.clear { image @comic_path }
            @status.text = comic_url
          }
      else
        @status.text = "Oops. Something’s blocked the tubes. Try again?"
      end
      
      progress_stop
    end
  end
  
  def progress_start
    @progress_timer = animate(24) do
      @progress_spinner.rotate(10)
    end
    @progress_spinner.show
  end
  
  def progress_stop
    @progress_timer.stop
    @progress_spinner.hide
  end
  
  background "#555"
  
  # Setting this width doesn’t seem to work
  stack :margin => 10 do
    title strong("Random Dinosaur Comic"), :align => "center", :stroke => "#DFA", :margin => 0
    
    @comic_placeholder = flow
    
    @status = caption "Hold on; we’re choosing a random comic...", :align => "center"
    
    flow do
      @progress_spinner = image "unicorn.jpg", :width => 50, :height => 50, :align => "center"
      
      @another_comic = button("Yes, I would like another.") do
        # TODO - how do I update this button’s text?
        # @another_comic.text = "Ok, hold on"
        progress_start
        random_comic
      end
    end
  end
  
  progress_start
  random_comic
end