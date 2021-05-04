# MIDIPainter
## Developed by Noah Leong
### A MIDI controller for use on iOS devices

## MIDIPainter Prerequisite Setup

To use the controller, plugin in an iOS device to a Mac computer via lightning cable. Once this is done, go to the Audio Midi setup, and find your iOS within the Audio devices. Enable the device and you should be set up to use MIDIPainter.

## Using MIDIPainter

With your iOS device's Audio/MIDI enabled open up the MIDIPainter app and start drawing. As you draw your lines you will see MIDI CCs show up in your DAW/Program of choice. Each additional line adds its own seperate MIDI CC Number, and as the ball moves back and forth within the line, corresponding values to the MIDI CCs are sent. 

MIDIPainter uses coordinates within your screen to determine the values of the MIDI CCs. The bottom left of your screen will give the smallest values, and the top right of your screen will give the largest values. 

Once you have drawn some lines, you can remove lines by touching the lines you have drawn once again. This will also remove the MIDI CC being sent from the respective line.