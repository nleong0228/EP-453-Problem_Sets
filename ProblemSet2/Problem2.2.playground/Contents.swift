import UIKit

var instrumentName = "Guitar"
var instrumentClass = "String"

instrumentName = "Classical " + instrumentName

var frequency = 440
var midi = 12*(log2f(Float(frequency/440)))+69

var isPlaying = true

print(instrumentName, "is a", instrumentClass, "Instrument and is currently playing MIDI note", midi, ":", isPlaying)


