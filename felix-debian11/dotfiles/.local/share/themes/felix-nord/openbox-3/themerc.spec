############################
# Data type: Justification
############################

Possible values are: Left, Center, Right

######################
# Date type: Texture
######################

parentrelative | ((solid | gradient gradient-type) [border] [interlaced])

A texture can be solid or gradient.
It can also have a border and being interlaced with a line.

## Solid

Solid means that the background of the texture is filled with a single color.
The texture must be accompanied by a single color field.

Example:
menu.items.bg:       Solid Flat
menu.items.bg.color: #f8f5f2

## Gradient

When a gradient is specified, it must be followed by the gradient's type.
Gradients all use two color fields: color and colorTo and must also be accompanied by these.

Valid gradient types are:

  - Diagonal - A gradient from the top left corner to the bottom right corner
  - CrossDiagonal - A gradient from the top right corner to the bottom left corner
  - Pyramid - A gradient that starts in all four corners and smooths to the center of the texture
  - Horizontal - A gradient from the left edge to the right
  - MirrorHorizontal - A gradient from the left edge to the middle, and then reversed to the right edge
  - Vertical - A gradient from the top edge to the bottom
  - SplitVertical - A gradient split in the middle that goes out toward the top and bottom edges 

Example:
menu.title.bg:         Gradient Vertical Raised 
menu.title.bg.color:   #658fb5
menu.title.bg.colorTo: #4d6982

SplitVertical gradients have 2 optional, addition color fields: color.splitTo and colorTo.splitTo.
These colors are the light colors used on the far top and bottom of the SplitVertical gradient.
When these are omitted, then the default values for these are color * 5/4, and colorTo * 17/16.

Example:
menu.title.bg:                 Gradient SplitVertical Raised 
menu.title.bg.color:           #658fb5
menu.title.bg.color.splitTo:   #7595b9
menu.title.bg.colorTo:         #4d6982
menu.title.bg.colorTo.splitTo: #557485

## Borders

Borders can be used on both solid and gradient textures.
Possible values are: Flat, Flat Border, Raised and Sunken.

Flat means no border at all.
Flat Border means a flat solid border.
When using a flat border, the texture must be accompanied by a border color.
When a border is not specified, Raised is assumed.

Raised and Sunken have two bevel options available to them.
By default, a bevel is drawn around the very outside of the texture.
If Bevel2 is specified, then the bevel is drawn slightly in from the edge.
This can be used to animate button presses/toggled states. 

The strength of the bevel highlights can also be determined by the theme, by using the highlight and shadow fields: 
  - highlight: specifies the strength of the light bevel.
    It is a value above or equal to 0, where 0 makes no highlight at all, 256 makes the highlight color 100% brighter, 512 makes the highlight color 200% brighter, and so on.
    The default highlight is 128 (which is a 50% increase in brightness).
  - shadow: The shadow field specifies the strength of the dark bevel.
    It is a value between 0 and 256, where 0 makes no shadow at all, and 256 makes a completely black shadow (100% decreased brightness).
    The default shadow is 64 (which is a 25% decrease in brightness).

Example:
window.inactive.button.disabled.bg:           Gradient Diagonal Raised
window.inactive.button.disabled.bg.color:     rgb:50/54/58
window.inactive.button.disabled.bg.colorTo:   black
window.inactive.button.disabled.bg.highlight: 128
window.inactive.button.disabled.bg.shadow:    64
window.inactive.button.toggled.pressed.bg:          Gradient Diagonal Raised Bevel2
window.inactive.button.toggled.pressed.bg.color:    rgb:50/54/58
window.inactive.button.toggled.pressed.bg.colorTo:  black

## Interlace

Interlaced textures have a solid line drawn horizontally every second row.
When you specify interlaced, the texture must be accompanied by an interlaced color. 

Example:
window.inactive.title.bg: Solid Flat Interlaced
window.inactive.title.bg.color: #f5f5f5
window.inactive.title.bg.interlace.color: #f6f6f6

##########
# Colors
##########

Themerc being a X resource database, X11 color names are allowed and new colors can be defined like below:
#define COLOR0  #1c1c1c

Colors can be specified in hex RGB color code (HTML), or in the format "rgb:rr/bb/gg" where rr/bb/gg are given in hexadecimal.

####################
# Theme properties
####################

border.width:								Specifies the size of the border drawn around window frames.
									Type: integer
									Default: 1
									Valid: [0..100]

padding.width:								Specifies the padding size, used for spacing out elements in the window decorations.
									This can be used to give a theme a more compact or a more relaxed feel.
									This specifies padding in the horizontal direction (and vertical direction if padding.height is not explicitly set).
									Type: integer
									Default: 3
									Valid: [0..100] 

padding.height:								Specifies the padding size, used for spacing out elements in the window decorations. 
									This can be used to give a theme a more compact or a more relaxed feel.
									This specifies padding in only the vertical direction.
									Type: integer
									Default: padding.width
									Valid: [0..100] 

window.client.padding.width:						Specifies the size of the left and right sides of the inner border.
									The inner border is drawn around the window, but inside the other decorations. 
									Type: integer
									Default: padding.width
									Valid: [0..100]

window.client.padding.height:						Specifies the size of the top and bottom sides of the inner border.
									The inner border is drawn around the window, but inside the other decorations. 
									Type: integer
									Default: window.client.padding.width
									Valid: [0..100] 

window.handle.width:							Specifies the size of the window handle. The window handle is the piece of decorations on the bottom of windows.
									A value of 0 means that no handle is shown. 
									Type: integer
									Default: 6
									Valid: [0..100] 

window.label.text.justify:						Specifies how window titles are aligned in the titlebar for both the focused and non-focused windows.
									Type: justification
									Default: Left

menu.border.color:							Specifies the border color for menus.
									Type: color
									Default: window.active.border.color

menu.border.width:							Specifies the size of the border drawn around menus.
									Type: integer
									Default: border.width
									Valid: [0..100] 

menu.items.active.bg:							Specifies the background for the selected menu entry (whether or not it is disabled).
									When it is parentrelative, then it uses the menu.items.bg which is underneath it.
									Type: texture
									Default: none
									Parentrelative: yes 

menu.items.active.disabled.text.color:					Specifies the text color for disabled menu entries when they are selected.
									Type: color
									Default: menu.items.disabled.text.color

menu.items.active.text.color:						Specifies the text color for normal menu entries when they are selected. 
									Type: color
									Default: black 

menu.items.bg:								Specifies the background for menus.
									Type: texture
									Default: none
									Parentrelative: no 

menu.items.disabled.text.color:						Specifies the text color for disabled menu entries. 
									Type: color
									Default: black 

menu.items.font:							Specifies the shadow for all menu entries. 
									Type: text shadow string
									Default: no shadow

menu.items.text.color:							Specifies the text color for normal menu entries. 
									Type: color
									Default: white 

menu.overlap.x:								Specifies how sub menus should overlap their parents. A positive value moves the submenu over top of their parent by that amount.
									A negative value moves the submenu away from their parent by that amount.
									Type: integer
									Default: menu.overlap
									Valid: [-100..100] 

menu.overlap.y:								Specifies how sub menus should be positioned relative to their parents.
									A positive value moves the submenu vertically down by that amount, a negative value moves it up by that amount.
									Type: integer
									Default: menu.overlap
									Valid: [-100..100] 

menu.separator.color:							The color of menu line separators.
									Type: color
									Default: menu.items.text.color

menu.separator.padding.height:						Specifies the space on the top and bottom of menu line separators.
									Type: integer
									Default: 3
									Valid: [0..100] 

menu.separator.padding.width:						Specifies the space on the left and right side of menu line separators.
									Type: integer
									Default: 6
									Valid: [0..100] 

menu.separator.width:							Specifies the size of menu line separators.
									Type: integer
									Default: 1
									Valid: [1..100] 

menu.title.bg:								Specifies the background for menu headers.
									When it is parentrelative, then it uses the menu.items.bg which is underneath it. 
									Type: texture
									Default: none
									Parentrelative: yes 

menu.title.text.color:							Specifies the text color for menu headers. 
									Type: color
									Default: black 

menu.title.text.font:							Specifies the shadow for all menu headers. 
									Type: text shadow string
									Default: no shadow 

menu.title.text.justify:						Specifies how text is aligned in all menu headers. 
									Type: justification
									Default: Left 

window.active.border.color:						Specifies the border color for the focused window. 
									Type: color
									Default: border.color

window.active.button.disabled.bg:					Specifies the background for titlebar buttons when they are disabled for the window.
									This element is for the focused window.
									When it is parentrelative, then it uses the window.active.title.bg which is underneath it. 
									Type: texture
									Default: none
									Parentrelative: yes 

window.active.button.disabled.image.color:				Specifies the color of the images in titlebar buttons when they are disabled for the window.
									This element is for the focused window. 
									Type: color
									Default: white 

window.active.button.hover.bg:						Specifies the background for titlebar buttons when the mouse is over them. 
									This element is for the focused window.
									When it is parentrelative, then it uses the window.active.title.bg which is underneath it.
									Type: texture
									Default: window.active.button.unpressed.bg
									Parentrelative: yes 

window.active.button.hover.image.color:					Specifies the color of the images in titlebar buttons when the button is toggled - such as when a window is maximized.
									This element is for the focused window. 
									Type: color
									Default: window.active.button.toggled.image.color

window.active.button.pressed.bg:					Specifies the background for titlebar buttons when they are being pressed by the user.
									This element is for the focused window.
									When it is parentrelative, then it uses the window.active.title.bg which is underneath it. 
									Type: texture
									Default: none
									Parentrelative: yes 

window.active.button.pressed.image.color:				Specifies the color of the images in titlebar buttons when they are being pressed by the user.
									This element is for the focused window. 
									Type: color
									Default: window.active.button.unpressed.image.color

window.active.button.toggled.hover.bg:					Specifies the default background for titlebar buttons if the user is pressing them with the mouse while they are toggled - such as when a window is maximized. 
									This element is for the focused window.
									When it is parentrelative, then it uses the window.inactive.title.bg which is underneath it. 
									Type: texture
									Default: window.active.button.toggled.unpressed.bg
									Parentrelative: yes 

window.active.button.toggled.hover.image.color:				Specifies the color of the images in the titlebar buttons when the mouse is hovered over them while they are in the toggled state - such as when a window is maximized.
									This element is for the focused window. 
									Type: color
									Default: window.active.button.toggled.unpressed.image.color

window.active.button.toggled.pressed.bg:				Specifies the default background for titlebar buttons if the user is pressing them with the mouse while they are toggled - such as when a window is maximized.
									This element is for the focused window.
									When it is parentrelative, then it uses the window.inactive.title.bg which is underneath it. 
									Type: texture
									Default: window.active.button.pressed.bg
									Parentrelative: yes

window.active.button.toggled.pressed.image.color:			Specifies the color of the images in the titlebar buttons if they are pressed on with the mouse while they are in the toggled state - such as when a window is maximized.
									This element is for the focused window.
									Type: color
									Default: window.active.button.pressed.image.color

window.active.button.toggled.unpressed.bg:				Specifies the default background for titlebar buttons when they are toggled - such as when a window is maximized.
									This element is for the focused window.
									When it is parentrelative, then it uses the window.inactive.title.bg which is underneath it. 
									Type: texture
									Default: window.active.button.toggled.bg
									Parentrelative: yes 

window.active.button.toggled.unpressed.image.color:			Specifies the color of the images in titlebar buttons when the button is toggled - such as when a window is maximized.
									This element is for the focused window. 
									Type: color
									Default: window.active.button.toggled.image.color

window.active.button.unpressed.bg:					Specifies the background for titlebar buttons in their default, unpressed, state.
									This element is for the focused window.
									When it is parentrelative, then it uses the window.active.title.bg which is underneath it. 
									Type: texture
									Default: none
									Parentrelative: yes 

window.active.button.unpressed.image.color:				Specifies the color of the images in titlebar buttons in their default, unpressed, state.
									This element is for the focused window. 
									Type: color
									Default: white 

window.active.client.color:						Specifies the color of the inner border for the focused window, drawn around the window but inside the other decorations. 
									Type: color
									Default: white 

window.active.grip.bg:							Specifies the background for the focused window's grips.
									The grips are located at the left and right sides of the window's handle.
									When it is parentrelative, then it uses the window.active.handle.bg which is underneath it. 
									Type: texture
									Default: none
									Parentrelative: yes 

window.active.handle.bg:						Specifies the background for the focused window's handle.
									The handle is the window decorations placed on the bottom of windows.
									Type: texture
									Default: none
									Parentrelative: no

window.active.label.bg:							Specifies the background for the focused window's titlebar label.
									The label is the container for the window title.
									When it is parentrelative, then it uses the window.active.title.bg which is underneath it. 
									Type: texture
									Default: none
									Parentrelative: yes 

window.active.label.text.color:						Specifies the color of the titlebar text for the focused window. 
									Type: color
									Default: black 

window.active.label.text.font:						Specifies the shadow for the focused window's title. 
									Type: text shadow string
									Default: no shadow 

window.active.title.bg:							Specifies the background for the focused window's titlebar. 
									Type: texture
									Default: none
									Parentrelative: no 


window.inactive.border.color:						Specifies the border color for all non-focused windows. 
									Type: color
									Default: window.active.border.color

window.inactive.button.disabled.bg:					Specifies the background for titlebar buttons when they are disabled for the window.
									This element is for non-focused windows.
									When it is parentrelative, then it uses the window.inactive.title.bg which is underneath it. 
									Type: texture
									Default: none
									Parentrelative: yes 

window.inactive.button.disabled.image.color:				Specifies the color of the images in titlebar buttons when they are disabled for the window.
									This element is for non-focused windows. 
									Type: color
									Default: black 

window.inactive.button.hover.bg:					Specifies the background for titlebar buttons when the mouse is over them.
									This element is for non-focused windows.
									When it is parentrelative, then it uses the window.inactive.title.bg which is underneath it. 
									Type: texture
									Default: window.inactive.button.unpressed.bg
									Parentrelative: yes 

window.inactive.button.hover.image.color:				Specifies the color of the images in titlebar buttons when the mouse is over top of the button.
									This element is for non-focused windows.
									Type: color
									Default: window.inactive.button.unpressed.image.color

window.inactive.button.pressed.bg:					Specifies the background for titlebar buttons when they are being pressed by the user.
									This element is for non-focused windows.
									When it is parentrelative, then it uses the window.inactive.title.bg which is underneath it. 
									Type: texture
									Default: none
									Parentrelative: yes 

window.inactive.button.pressed.image.color:				Specifies the color of the images in titlebar buttons when they are being pressed by the user.
									This element is for non-focused windows.
									This color is also used for pressed color when the button is toggled. 
									Type: color
									Default: window.inactive.button.unpressed.image.color

window.inactive.button.pressed.toggled.image.color:			Specifies the color of the images in the titlebar buttons if they are pressed on with the mouse while they are in the toggled state - such as when a window is maximized.
									This element is for non-focused windows.
									Type: color
									Default: window.inactive.button.pressed.image.color

window.inactive.button.toggled.hover.bg:				Specifies the default background for titlebar buttons if the user is pressing them with the mouse while they are toggled - such as when a window is maximized.
									This element is for non-focused windows.
									When it is parentrelative, then it uses the window.inactive.title.bg which is underneath it. 
									Type: texture
									Default: window.inactive.button.toggled.unpressed.bg
									Parentrelative: yes 

window.inactive.button.toggled.hover.image.color:			Specifies the color of the images in the titlebar buttons when the mouse is hovered over them while they are in the toggled state - such as when a window is maximized.
									This element is for non-focused windows. 
									Type: color
									Default: window.inactive.button.toggled.unpressed.image.color

window.inactive.button.toggled.pressed.bg:				Specifies the default background for titlebar buttons if the user is pressing them with the mouse while they are toggled - such as when a window is maximized.
									This element is for non-focused windows.
									When it is parentrelative, then it uses the window.inactive.title.bg which is underneath it. 
									Type: texture
									Default: window.inactive.button.pressed.bg
									Parentrelative: yes 

window.inactive.button.toggled.unpressed.bg:				Specifies the default background for titlebar buttons when they are toggled - such as when a window is maximized.
									This element is for non-focused windows.
									When it is parentrelative, then it uses the window.inactive.title.bg which is underneath it. 
									Type: texture
									Default: window.inactive.button.toggled.bg
									Parentrelative: yes 

window.inactive.button.toggled.unpressed.image.color:			Specifies the color of the images in titlebar buttons when the button is toggled - such as when a window is maximized.
									This element is for non-focused windows. 
									Type: color
									Default: window.inactive.button.toggled.image.color

window.inactive.button.unpressed.bg:					Specifies the background for titlebar buttons in their default, unpressed, state.
									This element is for non-focused windows.
									When it is parentrelative, then it uses the window.inactive.title.bg which is underneath it. 
									Type: texture
									Default: none
									Parentrelative: yes 

window.inactive.button.unpressed.image.color:				Specifies the color of the images in titlebar buttons in their default, unpressed, state.
									This element is for non-focused windows. 
									Type: color
									Default: white 

window.inactive.client.color:						Specifies the color of the inner border for non-focused windows, drawn around the window but inside the other decorations. 
									Type: color
									Default: white 

window.inactive.grip.bg:						Specifies the background for non-focused windows' grips.
									The grips are located at the left and right sides of the window's handle.
									When it is parentrelative, then it uses the window.inactive.handle.bg which is underneath it. 
									Type: texture
									Default: none
									Parentrelative: yes 

window.inactive.handle.bg:						Specifies the background for non-focused windows' handles.
									The handle is the window decorations placed on the bottom of windows. 
									Type: texture
									Default: none
									Parentrelative: no 

window.inactive.label.bg:						Specifies the background for non-focused windows' titlebar labels.
									The label is the container for the window title.
									When it is parentrelative, then it uses the window.inactive.title.bg which is underneath it. 
									Type: texture
									Default: none
									Parentrelative: yes 

window.inactive.label.text.color:					Specifies the color of the titlebar text for non-focused windows. 
									Type: color
									Default: white 

window.inactive.label.text.font:					Specifies the shadow for non-focused windows' titles. 
									Type: text shadow string
									Default: no shadow 

window.inactive.title.bg:						Specifies the background for non-focused windows' titlebars. 
									Type: texture
									Default: none
									Parentrelative: no 
