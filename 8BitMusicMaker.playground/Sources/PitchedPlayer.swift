import Foundation
import AVFoundation

class PitchedPlayer {

	let player = AVAudioPlayerNode()
	let timePitchEffect = AVAudioUnitTimePitch()
	let audioBuffer: AVAudioPCMBuffer

	init(engine: AVAudioEngine, audioBuffer: AVAudioPCMBuffer, note: Note) {
		self.audioBuffer = audioBuffer

		timePitchEffect.pitch = note.pitchModifier

		engine.attach(player)
		engine.attach(timePitchEffect)

		engine.connect(player, to: timePitchEffect, format: audioBuffer.format)
		engine.connect(timePitchEffect, to: engine.mainMixerNode, format: audioBuffer.format)
	}

	func play() {
		player.scheduleBuffer(audioBuffer, at: nil, options: [])
		player.play()
	}

	func stop() {
		player.stop()
	}
}
