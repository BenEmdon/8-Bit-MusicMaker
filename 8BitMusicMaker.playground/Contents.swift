import PlaygroundSupport
import UIKit
import AVFoundation

let path = playgroundSharedDataDirectory.appendingPathComponent("music.caf")

let bitMusicMaker = BitMusicMaker(
	with: [.triangle, .square],
	initialState: [:],
	numberOfBlocks: 20,
	beatsPerMinute: 140,
	saveURL: path
)
PlaygroundPage.current.liveView = bitMusicMaker
