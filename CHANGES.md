# Changes

## Unrelease

* Add support for custom events – any Riot message sent to a Mint Tea app will
  become an `Event.Custom msg` event, which enables sending data into TUIs from
  other processes.

* Add `key` type for key down events – this means we now get better
  discoverability of what key down events we can match on, and its easier to
  keep examples working

* Capture more key events: arrows (left,down,up,right), backspace, space,
  enter, escape.

* Move `initial_state` to the application start invocation – you can now run
  your app with multiple initial states, which makes it ideal for starting apps
  in the middle of other flows, or to test specific scenarios.


## 0.0.1

Initial release for the 3 packages.

#### MintTea

* Let people create TUI apps using The-Elm-Architecture
* Introduce basic events for KeyDown, Frame, and Timers
* Introduce basic commands for setting timers, entering/exiting the AltScreen, exiting, and sequencing commands

#### Examples

* Add `views` example showcasing an application with multiples sections
* Add `altscreen-toggle` example to showcase the AltScreen
* Add `fullscreen` example with a timer
* Add `stopwatch` example
* Add `fps` counter example

#### Spices

* Introduce `color` and `style`
* Support basic styles (bold, italic, underscore, etc) and layouting (padding) 

#### Leaves

* Add a Checkbox leaf
* Add a Progress bar leaf
