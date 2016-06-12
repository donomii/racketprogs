# IMAPbayes
Automatically sorts your mail based on your current folders

IMAPbayes reads all your mail folders when it starts up, and trains an automatic categoriser using those mail folders.  When new mail arrives, IB moves it to the correct folder (most of the time).

## Use

   perl autofilter.pl INBOX <password>
 
Autofilter will start reading all your mail, which can take a long time.  When it finishes, it will start moving your mail out of INBOX and into your mail folders.
 
## Configuring

Open the file and set the "server" and "user" config options.  You may also have to change the SSL and port settings, depending on your server

## Setup mail folders

If you already have your mail sorted into folders, you don't have to do anything more.  Otherwise, create some mail folders, and sort your mail into them.  

