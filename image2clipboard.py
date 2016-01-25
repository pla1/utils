#! /usr/bin/python

import pygtk
pygtk.require('2.0')
import gtk
import os
import sys

def copy_image(f):
    assert os.path.exists(f), "file does not exist"
    image = gtk.gdk.pixbuf_new_from_file(f)

    clipboard = gtk.clipboard_get()
    clipboard.set_image(image)
    clipboard.store()


copy_image(sys.argv[1]);
