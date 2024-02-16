# Changes

## 0.0.3

#### Mint Tea

* Upgrade to Riot 0.0.8 – this release brings stability fixes, performance
  fixes, and includes new microsecond resolution timers.

* Add better trace logs

* Make sure we restore and show the cursor on exit

* Fix bug where alt-screen rendering cleaned extra lines - thanks @jmcavanillas 👏

* Small doc fixes – thanks @sam-huckaby ✨

#### Spices

* Expose color type as Tty.Color.t for more flexibility and supporting fallback
  colors

* Implement rendering of padding – thanks @wonbyte 🚀

#### Leaves

* Add new Virtualized Table component with support for columns and moving a
  cursor around – thanks @sabine 🧡

* Progress bar now defaults color to gray if the terminal profile isn't
  supported

* Progress bar now can toggle the percentage number – thanks @wesleimp 🌈

## 0.0.2

#### Mint Tea

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

* Fix bug where TTY was not restored from RAW mode during normal shutdown.

* Now the `Event.Frame time` event includes the frame time, and all examples
  are updated to work with it.

* Add new `Hide_cursor` and `Show_cursor` commands, and always restore the
  cursor to visible on exit

#### Leaves

* New `Leaves.Fps` to specify a frame rate and cap updates at that rate (Thanks
  to @sabine)

* New `Leaves.Sprite` module to create frame-based animations that are ticked
  at a specific frame-rate (Thanks to @sabine)

* New `Leaves.Spinner` contains several spinners ready to be used in
  applications (Thanks to @sabine)

* New `Leaves.Text_input` field ready to be used in applications (Thanks to
  @lessp_)

* New `Leaves.Cursor` that can be used to highlight where the cursor is in a
  given text (Thanks to @nguermond)

* Reworked `Leaves.Progress` to support plain and gradient progress bars with
  customizable empty/full/trail characters, and to fit right into the
  make/update/view pattern.

#### Spices

* Implemented support for gradients between two RGB colors

#### Examples

* New Spinners example showcasing several spinners (Thanks to @sabine)

* New Emojis game example showcasing a tilemap and moving a player around

* New Basic example for the README tutorial

* New Progress bars examples showcasing plain, gradient, and emoji progress bars

* New Text input field example (Thanks to @lessp_)

* Updated other examples to use the new progress bars

#### Docs

* New tutorial starting from zero and building a small shopping list app
  (Thanks to @metame)

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
