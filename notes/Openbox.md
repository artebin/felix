# Openbox

## obapps
Missing dependencies:
- python-xlib
- python-wxgtk3.0

Cannot make it work on Ubuntu 18.04:
~~~~
Traceback (most recent call last):
  File "./obapps", line 480, in <module>
    main()
  File "./obapps", line 475, in main
    frame=WLFrame(None,-1,'OBApps')
  File "./obapps", line 450, in __init__
    appsel.SetModel(self.model)
  File "./obapps", line 86, in SetModel
    self.set_sel_and_focus(0)
  File "./obapps", line 159, in set_sel_and_focus
    self.list.Select(index,True)
  File "/usr/lib/python2.7/dist-packages/wx-3.0-gtk3/wx/_controls.py", line 4766, in Select
    self.SetItemState(idx, state, wx.LIST_STATE_SELECTED)
  File "/usr/lib/python2.7/dist-packages/wx-3.0-gtk3/wx/_controls.py", line 4529, in SetItemState
    return _controls_.ListCtrl_SetItemState(*args, **kwargs)
wx._core.PyAssertionError: C++ assertion "litem >= 0 && (size_t)litem < GetItemCount()" failed at ../src/generic/listctrl.cpp(3422) in SetItemState(): invalid list ctrl item index in SetItem
~~~~
