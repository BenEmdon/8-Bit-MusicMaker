/*:
# Mario Demo:

This demo shows off the beginning of the famous 8-Bit Super Mario Theme! Feel free to play around with it!

[👈 Back to Info](@previous) |
[👉 Next Demo](@next)

### Make sure the assitant editor is selected:
![Assitant Editor](AssitantEditor.jpg)
*/
import PlaygroundSupport
import UIKit

//: Here are the notes to the beginnig of the Super Mario Theme:
let marioTheme: Set<NoteAtBlock> = [
	NoteAtBlock(note: .D, block: 0),
	NoteAtBlock(note: .E2, block: 0),
	NoteAtBlock(note: .D, block: 1),
	NoteAtBlock(note: .E2, block: 1),
	NoteAtBlock(note: .D, block: 3),
	NoteAtBlock(note: .E2, block: 3),
	NoteAtBlock(note: .D, block: 5),
	NoteAtBlock(note: .C2, block: 5),
	NoteAtBlock(note: .D, block: 6),
	NoteAtBlock(note: .E2, block: 6),
	NoteAtBlock(note: .G, block: 8),
	NoteAtBlock(note: .G2, block: 8),
	NoteAtBlock(note: .G, block: 11),
	NoteAtBlock(note: .E, block: 14),
	NoteAtBlock(note: .G, block: 14),
	NoteAtBlock(note: .C2, block: 14),
	NoteAtBlock(note: .E, block: 16),
	NoteAtBlock(note: .G, block: 16),
	NoteAtBlock(note: .E, block: 19),
	NoteAtBlock(note: .C, block: 19),
	NoteAtBlock(note: .F, block: 21),
	NoteAtBlock(note: .A, block: 21),
	NoteAtBlock(note: .B, block: 23),
	NoteAtBlock(note: .G, block: 23),
	NoteAtBlock(note: .B, block: 25),
	NoteAtBlock(note: .G, block: 25),
	NoteAtBlock(note: .F, block: 26),
	NoteAtBlock(note: .A, block: 26),
]

// Configuration ⚙️:
let instruments: Set<Instrument> = [.square]
let initialState: [Instrument: Set<NoteAtBlock>] = [.square: marioTheme]
let numberOfBlocks: Int = 30
let blocksPerSecond: Double = 5.5
let numberOfOctaves: Note.NumberOfOctaves = .two

// Path corresponds to `/Users/{YOUR USER NAME}/Documents/Shared\ Playground\ Data`
let saveURL = playgroundSharedDataDirectory.appendingPathComponent("mario.caf")

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
[👈 Back to Info](@previous) |
[👉 Next Demo](@next)
*/
