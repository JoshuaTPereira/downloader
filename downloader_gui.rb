require_relative "downloader"
require "gtk3"

class DownloaderGUI

  def initialize
    @host = ""
    @username = ""
    @password = ""
    @to_download = ""
    @output = ""

    @console = StringIO.new
  end

  def download_arguments
    {
      host: @host,
      username: @username,
      password: @password,
      to_download: @to_download,
      output: @output
    }
  end

  def download
    @host = @host_field.text
    @username = @username_field.text
    @password = @password_field.text

    Downloader.new(download_arguments: self.download_arguments, exit_on_error: false, console: @console).download

    @console_text.buffer.text = @console.string
    @console = StringIO.new
  end

  def start
    app = Gtk::Application.new

    app.signal_connect "activate" do |application|
      window = Gtk::ApplicationWindow.new(application)
      window.set_title("Remote File Downloader")
      window.set_default_size(500, 200)
      window.set_position :center
      window.set_border_width(10)

      grid = Gtk::Grid.new
      window.add(grid)

      # Host
      @host_field = Gtk::Entry.new
      @host_field.set_text "Host"
      grid.attach(@host_field, 0, 0, 1, 1)

      # Username
      @username_field = Gtk::Entry.new
      @username_field.set_text "Username"
      grid.attach(@username_field, 1, 0, 1, 1)

      # Password
      @password_field = Gtk::Entry.new
      @password_field.set_text "Password"
      grid.attach(@password_field, 2, 0, 1, 1)

      # Files for Download
      @files_for_download_dialog = Gtk::FileChooserDialog.new("Select File",
                                                              window,
                                                              :open,
                                                              nil,
                                                              [Gtk::Stock::OPEN, :accept])

      button = Gtk::Button.new(:label => "Select Files for Download")
      button.signal_connect("clicked") do   
        if @files_for_download_dialog.run == :accept
          @to_download = @files_for_download_dialog.filename
        end

        @files_for_download_dialog.close

        # The #close method destroys the dialog object for whatever reason...
        @files_for_download_dialog = Gtk::FileChooserDialog.new("Select File",
                                                              window,
                                                              :open,
                                                              nil,
                                                              [Gtk::Stock::OPEN, :accept])
      end
      grid.attach(button, 0, 1, 1, 1)

      # Output Directory
      @output_directory_dialog = Gtk::FileChooserDialog.new("Select File",
                                                              window,
                                                              :open,
                                                              nil,
                                                              [Gtk::Stock::OPEN, :accept])

      button = Gtk::Button.new(:label => "Select Output Directory")
      button.signal_connect("clicked") do   
        if @output_directory_dialog.run == :accept
          @output = @output_directory_dialog.current_folder
        end

        @output_directory_dialog.close

        # The #close method destroys the dialog object for whatever reason...
        @output_directory_dialog = Gtk::FileChooserDialog.new("Select Directory",
                                                              window,
                                                              :open,
                                                              nil,
                                                              [Gtk::Stock::OPEN, :accept])
      end
      grid.attach(button, 1, 1, 1, 1)

      # Quit Button
      button = Gtk::Button.new(:label => "Quit")
      button.signal_connect("clicked") { window.destroy }
      grid.attach(button, 0, 2, 1, 1)

      # Download Button
      button = Gtk::Button.new(:label => "Download")
      button.signal_connect("clicked") { self.download }
      grid.attach(button, 1, 2, 1, 1)

      # Console
      @console_text = Gtk::TextView.new
      grid.attach(@console_text, 0, 3, 3, 3)

      window.show_all
    end

    app.run([$0] + ARGV)
  end
end

DownloaderGUI.new.start