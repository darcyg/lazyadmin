# Lazy Admin Usage Guide

## **Overview**

The basic functionality of Lazy Admin is to provide a pseudo graphical UI, one that can be navigated by the arrow keys, or with keyboard shortcuts, to hold script or command aliases on an easily navigable, tabbed menu-like interface. If you are a lazy sys admin, who is tired of typing long commands and cannot remember the aliases he set (it must come with age), you might even find it handy.

The biggest advantage of Lazy Admin over... well, probably over a graphical interface, is that it uses almost no external libraries. The whole thing runs as a `bash` script, occasionally making use of `sed`. There are some functions that use other packages, but these are carefully separated as plugins, making the core (hopefully) compatible with almost anything.

Again, if you are a sysadmin, who does a lot of remote server maintenance, you will find that Lazy Admin runs super fast over SSH. Because there is noting fancy to run, really.

## **Capacity**

If you have installed Lazy admin with the demo menus, it is already set to have six tabs, five of which are free to use (or even all six, if you remove the tab, each with five menu entries). That makes the default capacity of the main menu alone 25 commands or functions. (Or 30 if you remove the setup).

You can also use sub-menus, if you like, each could hold up to nine entries with the default settings. This means, with 5 times 5 main menus, each holding 9 sub-menus, theoretically your total number or entries would be 225...

If that is not enough, you could increase the main menu height. The maximum capacity of the main menu would be 9 entries for both menus and sub-menus. You could also add up to 10 tabs, if you use short enough names. This limitation is due to how Lazy Admin handles menu function aliases (single digits are only accepted at the moment)

Thus, the maximum capacity assuming 10 tabs, each with nine menus that hold nine sub-menus, is 10x9x9=810 entries. Now, each sub-menu item can hold a command builder (more on that later), which is technically one command, with a maximum of 9 built in predefined arguments or argument sets, plus the option to manually specify any (see below). That means a minimum of 9 types of combinations of that 810 commands, making the possible variations total to 7290, and then we still disregarded manual entries...

Now, if you have 810 (or 7290) commands or scripts to start with, you already are having serious issues...

## Command line arguments

Lazy Admin can be started by either typing `ladmin` as a command, or for the portable version by navigating to its folder and launching it with either`bash pladmin` or `./pladmin`.

The full installation and the full portable version take two command line arguments:

- `--join-lines` and
- `--load-profile`

### join-lines

`--join-lines` can override the default setting of the `$displaylineconnectors` variable. This is useful when accessing Lazy Admin via e.g. SSH, and the device used does not display Lazy Admin correctly. This can happen when using a terminal emulator for Android, which often do not use proper monospace font.

- `ladmin --join-lines off` will start Lazy Admin without drawing line-jonits, so that non-monospace 
- `ladmin --join-lines on` will force drawing  line-jonits, even when Lazy Admin is set not to draw them

### load-profile

`--load profile` can be used to load a custom user profile. This profile must be a directory, named anything, but with contents identical to the `user` folder located either in `~/.config/LazyAdmin/`, or the portable version's root folder. 

Run `ladmin --load-profile profilefolder` (obviously replacing `profilefolder` with the folder name containing the custom profile) to load different default (user) settings, different menus and user functions, etc.


## **Navigation**

Navigation is simple:

| <br />

* Change tabs by the left or right arrows.

| <br />

* Navigate the menus by the up and down arrows

| <br />

* Enter a sub-menu, or execute a command by pressing enter or the numeric key, corresponding to the menu-item's position.

| <br />

* Change to the right panel by pressing Ctrl + right arrow, and back to the left panel by Ctrl + left arrow

If a menu entry is skipped (this can be done by entering `skip` in its place in the menu file, can be handy for visual grouping), its position still counts. E.g. if you have an arrangement of a menu like this (with a gap between the 2nd and 3rd):

| `First entry`
| `Second entry`
|
| `Third entry`


You could select the "Second entry" by navigating there with the arrow keys, or by pressing number `2` on the keyboard. To select the "Third entry", you would have to press number `4`. That is because that entry has the #4 position in the menu (position #3 is empty).

To make navigation easier and more straightforward, it is recommended, that you name your menu entries preceded with the shortcut key, like this:

| `1 - First entry`
| `2 - Second entry`
|
| `4 - Third entry`


There is a special option on the right panel, called *Reflow menu*. Selecting this option, or its hotkey `f` will redraw the menu, and all its items. Use this when you resize the terminal emulator's window, or when the menu gets distorted for any reason.

## *Hotkeys*

All of the above mentioned actions and all the right panel options also have hotkeys assigned. This is to allow for faster navigation, and to provide an alternative to some keys that might be missing on certain devices (e.g. on a mobile-phone's terminal emulator over ssh).

The preset hotkeys are as follows:

| <br />

* Up -  w
* Down - s
* Left - a
* Right - d
* Change to right panel - r
* Change to left panel - l
* Back to previous level -b
* Select menu item 1 - 9
* Reflow menu - f
* Get help - h
* Display shortkeys - k
* Quit LazyAdmin - q

There are some reserved keys for certain setup menu items, so that you can still access them, even if you prefer not to display a Setup tab:

| <br />

* Edit menu entries - e
* Edit user functions - u
* Bind functions to menus - m
* Edit default values - v

In the command builder, you have three additional shortkeys, which you can only use inside a command builder menu:

| <br />

* Manually specify flags or arguments - m
* Clear all flags or arguments - x
* Run the command with the set flags or arguments - c

## **Command builder**
There is a special, visual command builder function built right into Lazy Admin, called the command builder. You can bind this interface to any menu or sub-menu item, and it will bring up a special type of sub-menu, allowing you to visually build long commands with preset flags, arguments, or sets of flags/arguments. To access this functionality, you need to bind `flags_submenu_funtion` with the right arguments to the menu or submenu item you wish to invoke the command builder with.

In the command builder menu, you can select an item by navigating to it, or pressing enter, and then the flag or argument bound to that item will be added to the build command. You can keep track of how your command looks below the menu. There is an option to manually enter any unspecified flags or arguments, to delete all set flags, and to run the built command. Currently the number of preset arguments or argument sets is limited to 9, so as to keep the number-shortkey functionality intact. The height of the command builder menu will dynamically change according to the number of preset arguments passed to it.

So if e.g. you want to ping *google.com* with five packets and get a verbose output, and you wish to do this 23 times a day, you could set up the `-v` and `-c 5` flags, and manually enter the domain to ping, like this:

Your flags options would be e.g.:

| `-v`
| `-c`
| `-c 5`
| `-n`
| `--help`

You would choose first `-v`, then `-c 5`

Now press `m` (or navigate there with the arrows) to manually enter the domain (google.com). So after pressing m, you would type:

`google.com`

This would result in the output:

`ping -v -c 5 google.com`

I am sure, you will find it very useful, if you love pinging google.com all day, every day...

> Note: Thee manual option is not reserved to the end of the sequence, you can set manual flags any time and continue adding predefined ones. E.g. the previous command could be done this way:

| <br />

1. select `c`

| <br />

2. press `m` and enter `5` <press enter>

| <br />

3. select `-v`

| <br />

4. press `m` and enter "google.com"

| <br />

5. press `c` to commit.

Of course, this may look as if it does not make any sense, and in this case you would be right. On the other hand, there are scenarios, when this could come in handy. Only I cannot think of any, not when I'm busy pinging google anyway.


## **Bottom row**

At the bottom of the UI, there is a special row, which displays a short one liner description of the currently highlighted menu item. These descriptions must be set at the same time menu items are set up, and are only available for menu and sub-menu items, and right panel items, but not for the command builder

That is all for now. I hope you find it useless, but fun to use.

I do.

If you want to know more about how to set up menus, and bind functions etc, head over to the next item in the help menu.

If you have any suggestions, or know something better, spotted an error, or just want to tell me that I'm an idiot for spending my time like this, just email me at:

[attila.orosz@mail.com](mailto:attila.orosz@mail.com)

Enjoy. :)
