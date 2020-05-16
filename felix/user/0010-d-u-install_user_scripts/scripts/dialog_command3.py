import Tkinter

class Application(Tkinter.Frame):
	def mygrab(self):
		print "grab is ok"
		root.grab_set_global()
	
	def createWidgets(self):
		self.QUIT = Tkinter.Button(self)
		self.QUIT["text"] = "QUIT"
		self.QUIT["command"] =  self.quit
		self.QUIT.pack({"side": "left"})
		self.grab = Tkinter.Button(self)
		self.grab["text"] = "Grab",
		self.grab["command"] = self.mygrab
		self.grab.pack({"side": "left"})        
	
	def __init__(self, master=None):
		Tkinter.Frame.__init__(self, master)
		self.pack()
		self.createWidgets()

root = Tkinter.Tk()
app = Application(master=root)
app.mainloop()
root.destroy()
