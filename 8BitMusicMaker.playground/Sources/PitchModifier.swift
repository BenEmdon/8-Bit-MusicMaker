import Foundation
import AVFoundation

class PitchModifier {

	let engine = AVAudioEngine()
	let player = AVAudioPlayerNode()
	let timePitchEffect = AVAudioUnitTimePitch()

	init(sample: AVAudioFile) {
		let audioBuffer = AVAudioPCMBuffer(pcmFormat: sample.processingFormat, frameCapacity: UInt32(sample.length))!
		try! sample.read(into: audioBuffer)

		engine.attach(player)
		engine.attach(timePitchEffect)

		engine.connect(player, to: timePitchEffect, format: audioBuffer.format)
		engine.connect(timePitchEffect, to: engine.mainMixerNode, format: audioBuffer.format)

		player.scheduleBuffer(audioBuffer, at: nil, options: .loops)
	}

	func start() {
		engine.prepare()
		try! engine.start()
		player.play()
	}
}
