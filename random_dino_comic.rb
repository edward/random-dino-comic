require "open-uri"
require 'rubygems'

random_comic = open('http://www.ohnorobot.com/random.pl?comic=23').read
actual_comic = "http://www.qwantz.com/" + random_comic[/(comics\/comic.*?png)/]

Shoes.app do
  stack :width => 200 do
    image(actual_comic)
    button "Load another"
  end
end