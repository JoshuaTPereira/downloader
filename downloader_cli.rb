require_relative "downloader"
require_relative "download_argument_parser"

Downloader.new(DownloaderArgumentParser.parse(ARGV)).download