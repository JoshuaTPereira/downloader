require 'net/scp'

class Downloader

  def initialize(download_arguments: {
    host: "",
    username: "",
    password: "",
    to_download: "",
    output: ""
  }, exit_on_error: true, console: $stdout)
    @download_arguments = download_arguments
    @exit_on_error = exit_on_error
    @console = console
  end

  def download
    host = @download_arguments[:host]
    username = @download_arguments[:username]
    password = @download_arguments[:password]
    to_download = @download_arguments[:to_download]
    output = @download_arguments[:output]

    @console.puts ""

    begin
      files_to_download = File.open(to_download).readlines.map(&:chomp)
    rescue StandardError
      @console.puts "ERROR: Unable to open to_download file"
      @console.puts "Check to_download file exists and is a txt document"
      if @exit_on_error
        exit 1
      else
        return
      end
    end

    begin
      if !File.directory?(output)
        @console.puts "ERROR: Given output is not a directory"
        if @exit_on_error
          exit 1
        else
          return
        end
      end
    # Output might be nil, hence the repeat
    rescue StandardError
      @console.puts "ERROR: Given output is not a directory"
      if @exit_on_error
        exit 1
      else
        return
      end
    end

    begin
      data = Net::SCP.start(host, username, password: password) do |scp|
        @console.puts "Download Started at #{username}@#{host} for files"
        files_to_download.each_with_index do |file, index|
          @console.puts "#{index + 1}. #{file}"
          scp.download(file, output)
        end
        @console.puts ""
        @console.puts "Download Complete"
      end
    rescue SocketError
      @console.puts "ERROR: Unable to connect to server"
      if @exit_on_error
        exit 1
      else
        return
      end
    rescue Net::SCP::Error
      @console.puts ""
      @console.puts "WARNING: Unable to download all files"
      @console.puts "Check file names and make sure each file is only seperated by a newline"
    end
  end
end