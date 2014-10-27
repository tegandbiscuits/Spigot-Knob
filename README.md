#Spigot Knob
Spigot Knob is a bundle of bash scripts to help run a Spigot Minecraft server.

#Usage
To run the scripts, you need to have bash and screen installed.
Download the script, and run config to build the config file. Your config file will be in the same directory as Spigot Knob (unless you change where it looks).

#Commands
`start` Starts the server in a detached screen named "spigot-server". Use `screen` to see the server running. You can't have more than one server running at a time (unless you want to modify the script).

`stop` Sends the stop signal to the server (sends a shutdown message to the players first). The command sleeps for the interval between the message and shutdown signal, so unfortunantly you just have to wait to continue (sorry).

`kill` Kills the "spigot-server" screen. Not very clean, and might actually make the server an orphan process

`restart` Restarts the server, by stopping then starting. The normal restart command stops the screen, so I had to improvise.

`reload-plugins` Reloads the server's plugins and settings.

`say` Say a message to the players as the server. Used as `say "hello world"`. Your message needs to be in quotes.

`save` Force saves the world to the disk.

`backup` Backs up the world (and nether & end), to the directory set in the config file as a .tar.gz. The naming is world-hr-min-dd-mm-yyyy. If directory where the backup is going to go doesn't exist, then it gets created automatically.

`backup-server` Backs up the directory the server runs in, to the backup directory as a .tar.gz. The name is server-backup-hr-min-dd-mm-yyyy. If the directory doesn't exist then it's created.

`screen` Attaches the screen the server is running in. If you're unfamiliar with using screen, use C-a C-d to detach it again.

`config` Runs the config utility. If there's already a file named knob.conf (if you've already ran config there will be) in the directory you're running Spigot Knob in, it will warn you and give you the option to overwrite it. Using ~ as home usually didn't work for me, so use the full path. Things in parentheses are the default values, just pressing enter keeps them that way.

`help` / `?` Shows the basic help info on the commands, and the version.

#Help & Contributing
If you have any problems or questions or a feature request, open an issue and I'll try to help out.
Feel free to add a feature or fix any bugs then send a pull request. Even little things are nice.

#License
The MIT License (MIT)

Copyright (c) 2014 Nate Rauh

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
