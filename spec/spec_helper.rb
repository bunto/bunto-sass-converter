# coding: utf-8
require 'fileutils'
require 'bunto'

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bunto-sass-converter'

if Bunto::VERSION > "1"
  Bunto.logger.log_level = :error
else
  Bunto.logger.log_level = Bunto::Stevenson::ERROR
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  SOURCE_DIR   = File.expand_path("../source", __FILE__)
  DEST_DIR     = File.expand_path("../dest",   __FILE__)
  SASS_LIB_DIR = File.expand_path("../other_sass_library", __FILE__)
  FileUtils.rm_rf(DEST_DIR)
  FileUtils.mkdir_p(DEST_DIR)

  def source_dir(*files)
    File.join(SOURCE_DIR, *files)
  end

  def dest_dir(*files)
    File.join(DEST_DIR, *files)
  end

  def sass_lib(*files)
    File.join(SASS_LIB_DIR, *files)
  end

  def site_configuration(overrides = {})
    Bunto.configuration(overrides.merge({
      "source"      => source_dir,
      "destination" => dest_dir
    }))
  end

  def scss_converter_instance(site)
    if Bunto::VERSION >= '3.0'
      site.find_converter_instance(Bunto::Converters::Scss)
    else
      site.getConverterImpl(Bunto::Converters::Scss)
    end
  end
end
