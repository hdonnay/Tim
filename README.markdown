Tim (Timer Script)
==================

Description
-----------
Terminal countdown timer with several modes written in POSIX shell script.
Currently Tim got a countdown timer, interval timer, pomodoro timer and magical
powers.

Usage
-----
It's really easy to play with Tim. Just run the script!

    ./tim h

Configuration
-------------
Read the file **timrc.example** for more information.

Dependencies
------------
You need to have a POSIX-compliant shell installed to run this.

When using the default settings, Tim can use:

- Mac OS X:
  - **afplay** - Comes with Mac OS X.
- GNU/Linux:
  - **aplay** - Comes with alsa-utils.
  - **mplayer** - The linux media player.

Tips
----
If you use Mac OS X you can put this in ~/.timrc to make it speak:

    WORK_CMD="say start working now"
    BREAK_CMD="say take a little break"
    POMODORO_CMD="say working session is over. take a break"

If you are sick of life you could try out this:

    TIMER_CMD="sudo rm -rf /"

Or if you need to celebrate after a pomodoro session:

    POMODORO_CMD="open rick-roll.avi"    # Mac OS X
    POMODORO_CMD="mplayer rick-roll.avi" # GNU/Linux

License
-------
Released under the BSD 2-Clause License.

    Copyright (c) 2012, Göran Gustafsson, Hank Donnay. All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

     Redistributions of source code must retain the above copyright notice, this
     list of conditions and the following disclaimer.

     Redistributions in binary form must reproduce the above copyright notice,
     this list of conditions and the following disclaimer in the documentation
     and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.

