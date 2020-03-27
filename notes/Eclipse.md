# Eclipse

## Eclipse
Minimal installation of Eclipse:

- Download the Eclipse platform <http://download.eclipse.org/eclipse/downloads/drops4/R-4.7.2-201711300510/>
- Go to `Help>Install New Software` and install the Eclipse Marketplace
- Install Java Development Tools (JDT) and Subversive using the Eclipse Marketplace
- Add the SVNKit repository <http://community.polarion.com/projects/subversive/download/eclipse/6.0/update-site/> from Polarion (see the Polarion website).
- Go to `Preferences>Java>Compiler>Building` and check `Circular dependencies=Warning`
- Go to `Preferences>Java>Editor` and disable "Smart caret positioning in Java names (overrides platform behavior)"
- Go to `Preferences>Java>Editor>Content Assist>Typing` and disable:
  - everything in "Automatically insert at correct position"
  - everything in "When pasting"
  - everything in "In string literals"
- Disallow GNOME Keyring in svnkit: `-Dsvnkit.library.gnome-keyring.enabled=false`

## Eclipse font rendering buggy with GTK3
It is because of "Use mixed fonts and color labels" settings 
See <https://bugs.eclipse.org/bugs/show_bug.cgi?id=465054>
