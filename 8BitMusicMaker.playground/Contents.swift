import PlaygroundSupport
import UIKit
import Foundation
import AVFoundation

struct NoteAtBlock {
	let note: Note
	let block: Int
}

extension NoteAtBlock: Hashable {
	static func ==(lhs: NoteAtBlock, rhs: NoteAtBlock) -> Bool {
		return lhs.block == rhs.block
			&& lhs.note == rhs.note
	}
	var hashValue: Int {
		return "\(note.rawValue).\(block)".hashValue
	}
}

protocol SequencerDelegate: class {}

class Sequencer {

	// constants
	let blocks = 12

	// AVFoundation dependancies
	let engine = AVAudioEngine()

	// Irganized state of the sequencer
	let buffers: [Instrument: AVAudioPCMBuffer]
	let players: [Instrument: [Note: PitchedPlayer]]
	var notesAtBlocks: [Instrument: Set<NoteAtBlock>]

	weak var delegate: SequencerDelegate?

	init(with instruments: [Instrument], initialState state: [Instrument: Set<NoteAtBlock>] = [:]) {
		buffers = Sequencer.audioBuffers(for: instruments)
		players = Sequencer.createPlayers(forBuffers: buffers, engine: engine)
		notesAtBlocks = state
	}

	func start() {
		engine.prepare()
		try! engine.start()
	}

	private static func audioBuffers(for instruments: [Instrument]) -> [Instrument: AVAudioPCMBuffer] {
		var audioBuffers = [Instrument: AVAudioPCMBuffer]()
		for instrument in instruments {
			let sample = instrument.sample
			let audioBuffer = AVAudioPCMBuffer(pcmFormat: sample.processingFormat, frameCapacity: UInt32(sample.length))!
			try! sample.read(into: audioBuffer)
			audioBuffers[instrument] = audioBuffer
		}
		return audioBuffers
	}

	private static func createPlayers(forBuffers buffers: [Instrument: AVAudioPCMBuffer], engine: AVAudioEngine) -> [Instrument: [Note: PitchedPlayer]] {
		var allPlayers = [Instrument: [Note: PitchedPlayer]]()
		let instruments = buffers.map { instrument, _ in return instrument }
		for instrument in instruments {
			var notePlayers = [Note: PitchedPlayer]()
			for note in Note.allValues {
				notePlayers[note] = PitchedPlayer(engine: engine, audioBuffer: buffers[instrument]!, note: note)
			}
			allPlayers[instrument] = notePlayers
		}
		return allPlayers
	}

	func registerNote(_ note: Note, onInstrument instrument: Instrument, forBlock block: Int) {
	}

	func playNote(_ note: Note, onInstrument instrument: Instrument) {
		// simple play a note
		if let player = players[instrument]?[note] {
			player.play()
		}
	}

	func stopNote(_ note: Note, onInstrument instrument: Instrument) {
		// simple play a note
		if let player = players[instrument]?[note] {
			player.stop()
		}
	}
}

class View: UIView {
	let sequencer = Sequencer(with: [.square])
	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
PlaygroundPage.current.liveView = view
view.sequencer.start()
view.sequencer.playNote(.A, onInstrument: .square)

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
	view.sequencer.playNote(.C, onInstrument: .square)
	view.sequencer.playNote(.E, onInstrument: .square)
}

DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
	view.sequencer.stopNote(.A, onInstrument: .square)
}
