#iCadeManager

iCadeManager is a simple class to make it easy to use the [iCade](http://www.ionaudio.com/products/details/icade) with Flash games. 

I wrote a blog post about this here: [struct.ca/2011/icademanager](http://struct.ca/2011/icademanager)

Created by Matt Rix - [@MattRix](http://twitter.com/MattRix) - matt[at]matt-rix.com

Please send me an email if you use this in your game, I'd love to put together a list of all the games that are using this.

To see it in action, check out this modified version of the Flixel EZPlatformer sample game: [struct.ca/ex/ezicade](http://struct.ca/ex/ezicade)

## Usage
- - -
    import flash.ui.Keyboard;
    import ca.struct.icade.iCadeManager;
    
    iCadeManager.start(stage);
    iCadeManager.mapControl(Keyboard["SPACE"],"A");
- - -

The iCade fires normal keyboard events. In the example above, button "A" on the iCade (the top left button) will fire keyboard events as if it was the spacebar. You can build your Flash games with normal keyboard support, and the iCade will simulate all the key presses so you don't have to change your game at all to support it. iCadeManager automatically assigns the joystick to the arrow keys, although it's possible to reassign those too if you want. 

To turn on iCade mode in your game, simply hold the top 4 buttons of the iCade controller (hold them again to turn it off). 

    Button names:
    [A][B][C][D]
    [E][F][G][H]

## Details
The iCade works as a normal bluetooth keyboard, the catch is that rather than each button acting like a single key, each button acts like two keys, one for button up, and one for button down. For example, the top left button fires as "Y" when pressed down, and a "T" when released. The joystick also first two keys for each of the four directions.

The problem is that there's no way to tell the difference between a normal keyboard and an iCade, and we don't want to be listening for the iCade's keys all the time (because it uses 24 letters). The solution I came up with is to only enable the iCade if you hold the top 4 buttons on the iCade at once. This way you can have a game that works like normal for regular keyboard players and then iCade players just have to turn on iCade mode by holding the top 4 buttons.

If you want to have iCade mode on all the time, just set `iCadeManager.isOn = true`, but I'd strongly recommended only using this when debugging, not when releasing your game to users.

## License: MIT

Copyright @2011 Matt Rix

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
