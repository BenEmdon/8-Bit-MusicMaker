import PlaygroundSupport
import UIKit
import AVFoundation

let path = playgroundSharedDataDirectory.appendingPathComponent("music.caf")

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


let bitMusicMaker = BitMusicMaker(
	with: [.square],
	initialState: [.square: marioTheme],
	numberOfBlocks: 30,
	beatsPerMinute: 300,
	saveURL: path,
	numberOfOctaves: .two
)
PlaygroundPage.current.liveView = bitMusicMaker

