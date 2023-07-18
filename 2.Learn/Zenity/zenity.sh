#!/usr/bin/env bash

: '
       zenity  is a program that will display GTK+ dialogs, and return (either in the
       return code, or on standard output)  the  users  input.  This  allows  you  to
       present information, and ask for information from the user, from all manner of
       shell scripts.

       For example, zenity --question will return either 0,  1  or  5,  depending  on
       whether  the user pressed OK, Cancel or timeout has been reached. zenity --en‐
       try will output on standard output what the user typed  into  the  text  entry
       field.

       Comprehensive documentation is available in the GNOME Help Browser.

Source: $ man zenity
'

firstname=$(zenity --entry --title="Your name" --text="What is your first name?")
surname=$(zenity --entry --title="Your name" --text="What is your surname?")

zenity --info --title="Hello!" --text="Welcome here.\n\nHave fun, $firstname $surname."
