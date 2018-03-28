/*:
# Empty Demo:

This demo is the perfect place to play around with 8-Bit Music Maker. Have fun with it!

[👈 Back to Mario Demo](@previous)

### Make sure the assitant editor is selected:
![Assitant Editor](AssitantEditor.jpg)
*/
import PlaygroundSupport
import UIKit

// Configuration ⚙️:
let instruments: Set<Instrument> = [.square, .triangle, .noise]
let initialState: [Instrument: Set<NoteAtBlock>] = [:]
let numberOfBlocks: Int = 15
let blocksPerSecond: Double = 4
let numberOfOctaves: Note.NumberOfOctaves = .one

// Path corresponds to `/Users/{YOUR USER NAME}/Documents/Shared\ Playground\ Data`
let saveURL = playgroundSharedDataDirectory.appendingPathComponent("music.caf")

// Create the 8-Bit Music Maker
let bitMusicMaker = BitMusicMaker(
	with: instruments,
	initialState: initialState,
	numberOfBlocks: numberOfBlocks,
	blocksPerSecond: blocksPerSecond,
	saveURL: saveURL,
	numberOfOctaves: numberOfOctaves
)

// Make the 8-Bit music maker the liveView
PlaygroundPage.current.liveView = bitMusicMaker
/*:
---
[👈 Back to Mario Demo](@previous)
*/
