#!ruby
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

directory = File.expand_path(File.dirname(__FILE__))
require File.join(directory, 'AoBane', 'cui')

AoBane::CUI.run(ARGV) or exit(1)