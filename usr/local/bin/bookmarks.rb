#!/usr/bin/env ruby
require 'cgi'

fname = "#{Dir.home}/.config/gtk-3.0/bookmarks"

puts File.read(fname).lines.grep(/file:/).map{|s| s.gsub(/file:\/\/([^ ]+) .*\n/, '\1')}.map{|s| CGI.unescape(s)}
