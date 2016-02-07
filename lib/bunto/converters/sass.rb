require 'sass'
require 'bunto/utils'
require 'bunto/converters/scss'

module Bunto
  module Converters
    class Sass < Scss
      safe true
      priority :low

      def matches(ext)
        ext =~ /^\.sass$/i
      end

      def syntax
        :sass
      end
    end
  end
end
