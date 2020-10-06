require 'optparse'
require "active_support"

class DownloaderArgumentParser
  ARGS = {
    host: {
      help_message:  "Remote server to download from",
      error_message: "Must supply a host"
    },
    username: {
      help_message: "User to log onto remote server",
      error_message: "Must supply a username"
    },
    password: {
      help_message: "Password for the user",
      error_message: "Must supply a password"
    },
    to_download: {
      help_message: "Path for the list of files to download",
      error_message: "Must supply a path for files to download"
    },
    output: {
      help_message: "Directory where downloaded files should go",
      error_message: "Must supply an output directory"
    },
    help: {
      help_message: "Prints this help"
    }
  }

  REQUIRED_ARGS = ARGS.except(:help)
  OPTIONAL_ARGS = ARGS.slice(:help)

  def self.parse(options)
    passed_args = {}

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: downloader.rb #{REQUIRED_ARGS.keys.map{|arg| "[--#{arg}]"}.join(" ")}"

      REQUIRED_ARGS.each do |arg, messages|
        opts.on("-#{arg.to_s[0]}", "--#{arg.to_s} #{arg.to_s.upcase}", "#{messages[:help_message]}") do |value|
          passed_args[arg] = value
        end
      end

      opts.on("--help", "#{OPTIONAL_ARGS[:help][:help_message]}") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)

    errors = []

    REQUIRED_ARGS.keys.each do |arg| 
      if passed_args[arg].nil?
        errors << REQUIRED_ARGS[arg][:error_message]
      end
    end

    if !errors.empty?
      puts errors.join(", ")
      exit 1
    end

    return passed_args
  end
end