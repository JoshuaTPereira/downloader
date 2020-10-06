Two interfaces are provided to scp files from a remote server:
    * A GUI located in downloader_gui.rb
    * A CLI located in downloader_cli.rb

'bundle install' to download and install the necessary dependencies

The GUI can be invoked with 'ruby downloader_gui.rb'
Once invoked, there are three text fields provided, one for Host, one for Username, and one for Password

* Host
    The name or ip of the remote server
* Username
    The username which you're using to connect to said remote server
* Password
    The password for said user (unnecessary if you're using a pair of authentication keys for passwordless ssh)

The next row has two buttons, one labeled "Select Files for Download" and one labeled "Select Output Directory"

* Select Files for Download
    On your local machine, create a txt file. In this txt file, create a list of file paths which you want to copy from the remote server to your local machine
    Each file path should be seperated by a single newline, ex:

        /home/user1/foo/bar/first_file.txt
        /home/user2/baz/second_file.jpg
        /var/logs/production.log

* Select Output Directory
    This is the directory in which each file will be copied to

The next row has two more buttons, one labeled "Quit" and one labeled "Download"

* Quit
    Exits the application

* Download
    Starts the download

Finally, on the next row, there is a text field for output
This will display any warnings or errors encountered while trying to parse the arguments / download the files

The CLI can be invoked with 'ruby downloader_cli.rb'
It is largely the same as the GUI, run 'ruby downloader_cli.rb --help' for a list of commands

Example CLI invocation:
'ruby downloader_cli.rb --host 127.0.0.1 --username bob --password password123 --to_download ~/Desktop/file_locations.txt --output ~/Desktop/Output'

Any errors or warnings will output to STDOUT when using the CLI