import PlaygroundSupport
import UIKit
import AVFoundation

let path = playgroundSharedDataDirectory.appendingPathComponent("music.caf")

let bitMusicMaker = BitMusicMaker(
	with: [.triangle, .square],
	initialState: [:],
	numberOfBlocks: 10,
	beatsPerMinute: 140,
	saveURL: path,
	numberOfOctaves: .one
)
PlaygroundPage.current.liveView = bitMusicMaker

