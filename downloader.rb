class Downloader

  def initialize(options)
    @options = options
  end

  def download
    host = @options[:host]
    username = @options[:username]
    password = @options[:password]
    to_download = @options[:to_download]
    output = @options[:output]

    puts ""

    begin
      files_to_download = File.open(to_download).readlines.map(&:chomp)
    rescue StandardError
      puts "ERROR: Unable to open to_download file"
      puts "Check to_download file exists and is a txt document"
      exit 1
    end

    if !File.directory?(output)
      puts "ERROR: Given output is not a directory, exiting..."
      exit 1
    end

    begin
      data = Net::SCP.start(host, username, password: password) do |scp|
        puts "Download Started at #{username}@#{host} for files"
        files_to_download.each_with_index do |file, index|
          puts "#{index + 1}. #{file}"
          scp.download(file, output)
        end
        puts ""
        puts "Download Complete"
      end
    rescue SocketError
      puts "ERROR: Unable to connect to server"
      exit 1
    rescue Net::SCP::Error
      puts ""
      puts "WARNING: Unable to download all files"
      puts "Check file names and make sure each file is only seperated by a newline"
    end
  end
end