# Generic Character 3D
This project is an example of 3D characters using the [Modular Character Controller](https://github.com/PantheraDigital/Modular-Character-Controller-for-Godot). \
**Modular Character Controller:** v2.0 \
**Godot:** v4.4 - 4.6

[video](https://www.youtube.com/watch?v=S7sfsYb2C7Q)

**Included:**
- two example characters
  - [simple](Generic-Character-3D/scenes/SimpleCharacter.tscn) : This displays the Godot CharacterBody3D Basic Movement template adapted to this system.
  - [example](Generic-Character-3D/scenes/ExampleCharacter.tscn) : An animated character using more of the features this system provides (a closer representation of the average playable character).
- [demo level](Generic-Character-3D/scenes/Level.tscn) : A scene with both characters set up to allow the player to swap between them.
- [action pickup](Generic-Character-3D/scenes/DashPickup.tscn) : An example of an object adding an action to a character at runtime.

**Controls:** 
- w,a,s,d: _move_ 
- mouse: _look_ 
- space: _jump_ 
- alt: _dash_ (after walking into pickup) 
- tab: _swap characters_

Third person character specific controls: 
- shift: _run_ 
- double tap space: _toggle flying_ 
- q/e (while flying): _fly up/fly down_

In the level there are two characters. One is the Simple Character (first person) and the other the Example Character (third person). The Simple Character  is the equivalent of using Godot's CharacterBody3D's Basic Movement template script. The Example Character uses a more complex set up to display a more common set of actions a character may have, including the use of root motion and actions blocking or interrupting each other. Use the dash action to see these at play (jump will interrupt the dash after about half the slide).

In the level is also a purple cube that will add a "Dash" action to any character that walks into it.

