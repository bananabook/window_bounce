# window_bounce
bash script to have a window bounce around the screen

</hr>
<img src="./example.gif" alt="example" height="720">

# Prerequisits
This script relies on functions for the X11 server. It does not work for wayland or similar, because there are no comparable functions for these. There is [ydotool](https://github.com/ReimuNotMoe/ydotool) but it does not offer the functions needed.

You need the following functions installed:
```
- xdpyinfo
- xwininfo
- xdotool
```

# Usage
1. run the script bounce.sh
2. click on the window you want to bounce. It can be the terminal window you run the script in, but it can be any other window as well. 
3. the window you selected now should be bouncing around.
4. Press Ctrl+C in the terminal window you ran the script in to stop the script

# Known Issues
In gnome there seems to be an offset, that makes the windows bounce before they touch the actual border of the screen, also the windows behave unexpectedly when they interact with the sidebar. 
