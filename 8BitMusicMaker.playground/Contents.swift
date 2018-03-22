import PlaygroundSupport
import UIKit
import Foundation
import AVFoundation

/// Each instriment is a sample of a different 8-bit wave form.
/// All samples are each wave form as a C2 note.
///
/// - square: square wave form.
/// - triangle: traingle wave from.
/// - noise: noisy wave. Imagine a ragged mountain surface.
enum Instrument: String {
	case square
	case triangle
	case noise

	var sample: AVAudioFile {
		let url = Bundle.main.url(forResource: "8-bit-" + rawValue, withExtension: "mp3")!
		return try! AVAudioFile(forReading: url)
	}
}

/// An enum that defines each notes pitch relative to the note C.
/// This assumes that the provided sound assets are a C note.
///
/// - C: Do
/// - D: Re
/// - E: Mi
/// - F: Fa
/// - G: Sol
/// - A: La
/// - B: Ti
public enum Note: Float {
	case C = 0
	case D = 10
	case E = 20
	case F = 25
	case G = 35
	case A = 45
	case B = 55
}

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

class View: UIView {
	let pitchModifier = PitchModifier(sample: Instrument.square.sample)
	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
PlaygroundPage.current.liveView = view
view.pitchModifier.start()
