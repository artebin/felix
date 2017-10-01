#import pdb
#pdb.set_trace()

from dbus.mainloop.glib import DBusGMainLoop
import dbus
import gobject
import logging

logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

dbus_loop = DBusGMainLoop(set_as_default=True)

def message_callback(bus, message):
	if message.get_interface() == "org.mpris.MediaPlayer2.Player":
		logger.info( message )
		power = dbus.get('org.freedesktop.MediaPlayer.GetMetadata')

session = dbus.SessionBus(mainloop=dbus_loop)
session.add_match_string_non_blocking("interface='org.mpris.MediaPlayer2.Player'")
session.add_message_filter(message_callback)

logger.info("Starting up.")
loop = gobject.MainLoop()
loop.run()
