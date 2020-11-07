# Window Tiling

## Openbox shortcuts in rc.xml

Adapted from <https://forums.bunsenlabs.org/viewtopic.php?id=3946>

	<!-- MoveResizeTo Bottom left quarter -->
	<keybind key="W-S-z">
		<action name="UnmaximizeFull"/>
		<action name="Raise"/>
		<action name="MoveResizeTo">
			<x>0</x>
			<y>50%</y>
			<width>50%</width>
			<height>50%</height>
		</action>
	</keybind>
	
	<!--MoveResizeTo Bottom half of screen -->
	<keybind key="W-S-x">
		<action name="UnmaximizeFull"/>
		<action name="Raise"/>
		<action name="MoveResizeTo">
			<x>0</x>
			<y>50%</y>
			<width>100%</width>
			<height>50%</height>
		</action>
	</keybind>
	
	<!--MoveResizeTo Bottom right quarter -->
	<keybind key="W-S-c">
		<action name="UnmaximizeFull"/>
		<action name="Raise"/>
		<action name="MoveResizeTo">
			<x>50%</x>
			<y>50%</y>
			<width>50%</width>
			<height>50%</height>
		</action>
	</keybind>
	
	
	<!-- MoveResizeTo Left half of screen -->
	<keybind key="W-S-a">
		<action name="UnmaximizeFull"/>
		<action name="MaximizeVert"/>
		<action name="Raise"/>
		<action name="MoveResizeTo">
			<width>50%</width>
			<x>0</x>
			<y>0</y>
		</action>
	</keybind>
	
	<!-- Move windows to the center -->
	<keybind key="W-S-s">
		<action name="UnmaximizeFull"/>
		<action name="Raise"/>
		<action name="MoveResizeTo">
			<x>center</x>
			<y>center</y>
			<width>75%</width>
			<height>75%</height>
		</action>
	</keybind>
	
	<!--MoveResizeTo Right half of screen -->
	<keybind key="W-S-d">
		<action name="UnmaximizeFull"/>
		<action name="MaximizeVert"/>
		<action name="Raise"/>
		<action name="MoveResizeTo">
			<width>50%</width>
			<x>50%</x>
			<y>0</y>
		</action>
	</keybind>
	
	<!--MoveResizeTo Top left quarter -->
	<keybind key="W-S-q">
		<action name="UnmaximizeFull"/>
		<action name="Raise"/>
		<action name="MoveResizeTo">
			<x>0</x>
			<y>0</y>
			<width>50%</width>
			<height>50%</height>
		</action>
	</keybind>
	
	<!--MoveResizeTo Top half of screen -->
	<keybind key="W-S-w">
		<action name="UnmaximizeFull"/>
		<action name="Raise"/>
		<action name="MoveResizeTo">
			<x>0</x>
			<y>0</y>
			<width>100%</width>
			<height>50%</height>
		</action>
	</keybind>
	
	<!--MoveResizeTo Top right quarter -->
	<keybind key="W-S-e">
		<action name="UnmaximizeFull"/>
		<action name="Raise"/>
		<action name="MoveResizeTo">
			<x>50%</x>
			<y>0</y>
			<width>50%</width>
			<height>50%</height>
		</action>
	</keybind>

# Openbox and Xorg resize hints

  - <http://icculus.org/pipermail/openbox/2013-January/007772.html>
  - <https://stackoverflow.com/questions/28369999/awesome-wm-terminal-window-doesnt-take-full-space>
  - <https://unix.stackexchange.com/questions/473183/how-to-configure-openbox-to-ignore-the-size-hint-of-a-specific-applications-win>
  
