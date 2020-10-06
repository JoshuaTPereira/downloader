require_relative "downloader"
require_relative "download_argument_parser"

Downloader.new(download_arguments: DownloaderArgumentParser.parse(ARGV), exit_on_error: true).download