# zbs-moaiutil
ZBS integration for Moai via Pito

Requirements
------------
Requires latest version of moai community tools from moaiforge here: https://github.com/moaiforge/moai-community

Requires moai sdk (1.7) from https://github.com/moaiforge/moai-sdk  (checkout the moai-develop branch)

Installation
------------

 * copy `zbs-moaiutil.lua` and `zbs-moaiutil` folder into `~/.zbstudio/packages` or `<path_to_zbstudio>/packages`
 * launch ZBS and configure plugin by using the `Pito` menu and selecting `Configure Plugin...`
 
Usage and Features
------------------

This plugin installs a "Pito" interpreter to ZBS which will run your project using your compiled hosts from your host folder 
and falls back to bundled moai binaries when host projects not found or not built. 

You can toggle whether to run on the Desktop host, or the Android host using the Pito menu. 

This plugin allows you to use Zerobrane's awesome debugging on android and desktop hosts (with iOS hosts coming soon) including functional REPL

Coming Later
------------
 * Enhanced moai debugging enabled by default, so you don't just see <MOAIProp 0x234234234> but instead a breakdown of all the attributes
   and properties of the prop.
 * Debug for iOS on simulator
 * Debug for iOS on device (maybe, if I can get fruitstrap going)

Distant Future
--------------
 * Custom debugging for MOAI including memory usage, frame rate/times, action tree display.


Contributions
-------------

This plugin is at the point where it is useful to share, but contributions are welcome if you clean it up or add iOS support.

 
