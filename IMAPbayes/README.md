# IMAPbayes
Automatically sorts your mail based on your current folders

IMAPbayes reads all your mail folders when it starts up, and trains an automatic categoriser using those mail folders.  When new mail arrives, IB moves it to the correct folder (most of the time).

## Use

    perl autofilter.pl INBOX

Autofilter will start reading all your mail, which can take a long time.  When it finishes, it will start moving your mail out of INBOX and into your mail folders.

If you are using MacOSX, then IB will announce each new mail as it is sorted.

## Configuring

Open the file "config.perl", and set the "server", "user", and password config options.  You may also have to change the SSL and port settings, depending on your server

## Setup mail folders

If you already have your mail sorted into folders, you don't have to do anything more.  Otherwise, create some mail folders, and sort your mail into them.

IB will move your new mail into these folders, choosing the folder based on how close the new mail matches the mail in the folders.

# Notes

* IB will not announce any mail that goes to a folder that has "spam" as part of its name.
* IB does not ever access these folders: Draft, Sent, Deleted, Trash

# Dependencies

    Net::IMAP::Client 
    Algorithm::NaiveBayes

You can install these with 

    cpan Net::IMAP::Client Algorithm::NaiveBayes
