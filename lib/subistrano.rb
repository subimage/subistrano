require "subistrano/version"

module Subistrano
  if defined?(Capistrano)
    Dir.glob("#{File.dirname(__FILE__)}/subistrano/recipes/*.rb").each { |t| require t }
  end
end
