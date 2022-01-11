#!/usr/bin/env python

import pygtk
pygtk.require('2.0')
import gtk
import os
import getpass

class exit:
	def disable_buttons(self):
		self.cancel.set_sensitive(False)
		self.logout.set_sensitive(False)
		self.reboot.set_sensitive(False)
		self.shutdown.set_sensitive(False)

	def cancel_action(self,btn):
		self.disable_buttons()
		gtk.main_quit()

	def logout_action(self,btn):
		self.disable_buttons()
		self.status.set_label("Exiting Openbox, please standby ...")
		os.system("openbox --exit")

	def reboot_action(self,btn):
		self.disable_buttons()
		self.status.set_label("Rebooting, please standby ...")
		os.system("systemctl reboot")

	def shutdown_action(self,btn):
		self.disable_buttons()
		self.status.set_label("Shutting down, please standby ...")
		os.system("systemctl poweroff")

	def create_window(self):
		self.window = gtk.Window()
		title = "Exit session for " + getpass.getuser() + "? Choose an option:"
		self.window.set_title(title)
		self.window.set_border_width(5)
		self.window.set_size_request(600, 80)
		self.window.set_resizable(False)
		self.window.set_keep_above(True)
		self.window.stick
		self.window.set_position(1)
		self.window.connect("delete_event", gtk.main_quit)
		windowicon = self.window.render_icon(gtk.STOCK_QUIT, gtk.ICON_SIZE_DIALOG)
		self.window.set_icon(windowicon)

		
		#Create HBox for buttons
		self.button_box = gtk.HBox()
		self.button_box.show()
		
		#Cancel button
		self.cancel = gtk.Button(stock = gtk.STOCK_CANCEL)
		self.cancel.set_border_width(4)
		self.cancel.connect("clicked", self.cancel_action)
		self.button_box.pack_start(self.cancel)
		self.cancel.show()
		
		#Logout button
		self.logout = gtk.Button("_Log out")
		self.logout.set_border_width(4)
		self.logout.connect("clicked", self.logout_action)
		self.button_box.pack_start(self.logout)
		self.logout.show()
		
		#Reboot button
		self.reboot = gtk.Button("_Reboot")
		self.reboot.set_border_width(4)
		self.reboot.connect("clicked", self.reboot_action)
		self.button_box.pack_start(self.reboot)
		self.reboot.show()
		
		#Shutdown button
		self.shutdown = gtk.Button("_Power off")
		self.shutdown.set_border_width(4)
		self.shutdown.connect("clicked", self.shutdown_action)
		self.button_box.pack_start(self.shutdown)
		self.shutdown.show()
		
		#Create HBox for status label
		self.label_box = gtk.HBox()
		self.label_box.show()
		self.status = gtk.Label()
		self.status.show()
		self.label_box.pack_start(self.status)
		
		#Create VBox and pack the above HBox's
		self.vbox = gtk.VBox()
		self.vbox.pack_start(self.button_box)
		self.vbox.pack_start(self.label_box)
		self.vbox.show()
		
		self.window.add(self.vbox)
		self.window.show()
		
	def __init__(self):
		self.create_window()


def main():
    gtk.main()

if __name__ == "__main__":
    go = exit()
    main()
