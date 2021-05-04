# MIDIPainter Design
### Developed by Noah Leong

## Creating MIDIPainter

The idea behind this project largely came from Kentaro Suzuki's M4L device "LFO Sketch". Where drawn lines become an LFO of sorts. I wanted to expand on this idea of drawing for sonic control via touch devices like the iPhone and iPad. 

To create the app, I started by looking in to line drawing apps/games that used user drawn lines to designate a path for game objects to follow. In order to accomplish this, I found SpriteKit to be the most sensible option for developing my app.

For this app, I created a variety of functions for creating lines, circles, and actions. Lines are created by accessing the `pathArray`, an array of `CGPoint`'s that are appended on every time the user moves their finger on the screen. Once the user lifts their finger, the line is created with a corresponding circle that follows the line's path via the `AKAction`, "`Follow`". On the user's touch down, the `pathArray` is cleared, and MIDI messages that follow the circle's position are sent. 

Within the `touchUp` function, also lies the operations for removing lines. To circumvent confusion between creating a line and removing a line, the program checks if the user is touching an existing line before creating a line. If the user is touching an existing line, the `remove` function is called. This function removes the line and circle from it's parent node, along with removing the circle from the `circleArray` to update the CC numbers.
