# encoding: utf-8

require 'sass'
require 'bunto/utils'

module Bunto
  module Converters
    class Scss < Converter
      BYTE_ORDER_MARK = /^\xEF\xBB\xBF/
      SyntaxError = Class.new(ArgumentError)

      safe true
      priority :low

      ALLOWED_STYLES = %w(nested expanded compact compressed).freeze

      def matches(ext)
        ext =~ /^\.scss$/i
      end

      def output_ext(ext)
        ".css"
      end

      def safe?
        !!@config["safe"]
      end

      def bunto_sass_configuration
        options = @config["sass"] || {}
        unless options["style"].nil?
          options["style"] = options["style"].to_s.gsub(/\A:/, '').to_sym
        end
        options
      end

      def sass_build_configuration_options(overrides)
        if safe?
          {
            :load_paths => sass_load_paths,
            :syntax     => syntax,
            :style      => sass_style,
            :cache      => false
          }
        else
          Bunto::Utils.symbolize_hash_keys(
            Bunto::Utils.deep_merge_hashes(
              bunto_sass_configuration,
              overrides
            )
          )
        end
      end

      def syntax
        :scss
      end

      def sass_dir
        return "_sass" if bunto_sass_configuration["sass_dir"].to_s.empty?
        bunto_sass_configuration["sass_dir"]
      end

      def sass_style
        style = bunto_sass_configuration.fetch("style", :compact)
        ALLOWED_STYLES.include?(style.to_s) ? style.to_sym : :compact
      end

      def user_sass_load_paths
        Array(bunto_sass_configuration["load_paths"])
      end

      def sass_dir_relative_to_site_source
        Bunto.sanitized_path(@config["source"], sass_dir)
      end

      def sass_load_paths
        if safe?
          [sass_dir_relative_to_site_source]
        else
          (user_sass_load_paths + [sass_dir_relative_to_site_source]).uniq
        end.select { |load_path| File.directory?(load_path) }
      end

      def allow_caching?
        !safe?
      end

      def add_charset?
        !!bunto_sass_configuration["add_charset"]
      end

      def sass_configs
        sass_build_configuration_options({
          "syntax"     => syntax,
          "cache"      => allow_caching?,
          "load_paths" => sass_load_paths
        })
      end

      def convert(content)
        output = ::Sass.compile(content, sass_configs)
        replacement = add_charset? ? '@charset "UTF-8";' : ''
        output.sub(BYTE_ORDER_MARK, replacement)
      rescue ::Sass::SyntaxError => e
        raise SyntaxError.new("#{e.to_s} on line #{e.sass_line}")
      end
    end
  end
end
