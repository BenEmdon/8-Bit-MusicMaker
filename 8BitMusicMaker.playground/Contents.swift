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

protocol SequencerDelegate: class {
	func blockChanged(_ block: Int)
	func sequencerModeChanged(_ mode: Sequencer.Mode)
}

class Sequencer {

	enum Mode {
		case playing
		case stopped
	}

	// Constants
	let blocks = 12

//	let blocksPerSecond: DispatchTime = 0.5

	// AVFoundation dependancies
	let engine = AVAudioEngine()

	// Organized state of the sequencer
	let players: [Instrument: [Note: PitchedPlayer]]
	public private(set) var notesAtBlocks: [Instrument: Set<NoteAtBlock>]
	var notesPlaying = [Instrument: Note]()
	var currentMode: Mode = .stopped

	weak var delegate: SequencerDelegate?

	init(with instruments: [Instrument], initialState state: [Instrument: Set<NoteAtBlock>] = [:]) {
		let buffers = Sequencer.audioBuffers(for: instruments)
		players = Sequencer.createPlayers(forBuffers: buffers, engine: engine)
		notesAtBlocks = state
	}

	// MARK: Static dispatched setup functions

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

	// MARK: Sequencer behavior

	func prepareForPlaying() {
		engine.prepare()
		try! engine.start()
	}

	func hardStop() {
		currentMode = .stopped
		for (instrument, notesAtBlocks) in notesAtBlocks {
			let notesInBlock = notesAtBlocks
				.map { noteAtBlock in noteAtBlock.note }
			print(notesInBlock)
			notesInBlock.forEach { note in stopNote(note, onInstrument: instrument) }
		}
	}

	func start() {
		currentMode = .playing
		sequenceNotes(forNewBlock: 0, oldBlock: nil)
	}

	func sequenceNotes(forNewBlock newBlock: Int, oldBlock: Int?) {
		if let oldBlock = oldBlock {
			stopNotesForBlock(oldBlock)
		}
		guard currentMode == .playing else { return }
		delegate?.blockChanged(newBlock)
		playNotesForBlock(newBlock)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
			guard let blocks = self?.blocks else { return }
			let allButLastBlock = 0..<(blocks - 1)
			if allButLastBlock.contains(newBlock) {
				self?.sequenceNotes(forNewBlock: newBlock + 1, oldBlock: newBlock)
			} else {
				self?.sequenceNotes(forNewBlock: 0, oldBlock: newBlock)
			}
		}
	}

	private func playNotesForBlock(_ block: Int) {
		for (instrument, notesAtBlocks) in notesAtBlocks {
			let notesInBlock = notesAtBlocks
				.filter { noteAtBlock in noteAtBlock.block == block }
				.map { noteAtBlock in noteAtBlock.note }
			notesInBlock.forEach { note in playNote(note, onInstrument: instrument) }

		}
	}

	private func stopNotesForBlock(_ block: Int) {
		for (instrument, notesAtBlocks) in notesAtBlocks {
			let notesInBlock = notesAtBlocks
				.filter { noteAtBlock in noteAtBlock.block == block }
				.map { noteAtBlock in noteAtBlock.note }
			notesInBlock.forEach { note in stopNote(note, onInstrument: instrument) }
		}
	}

	func registerNote(_ note: Note, onInstrument instrument: Instrument, forBlock block: Int) {
	}

	func playNote(_ note: Note, onInstrument instrument: Instrument) {
		// simple play a note
		players[instrument]![note]!.play()
	}

	func stopNote(_ note: Note, onInstrument instrument: Instrument) {
		// simple play a note
		players[instrument]![note]!.stop()
	}
}

class View: UIView {
	let sequencer = Sequencer(with: [.square], initialState: [
		.square: [
			NoteAtBlock(note: .C, block: 0),
			NoteAtBlock(note: .D, block: 1),
			NoteAtBlock(note: .E, block: 2),
			NoteAtBlock(note: .F, block: 3),
			NoteAtBlock(note: .G, block: 4),
			NoteAtBlock(note: .A, block: 5),
			NoteAtBlock(note: .B, block: 6),
			NoteAtBlock(note: .A, block: 7),
			NoteAtBlock(note: .G, block: 8),
			NoteAtBlock(note: .F, block: 9),
			NoteAtBlock(note: .E, block: 10),
			NoteAtBlock(note: .D, block: 11),
		]
	])
	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
PlaygroundPage.current.liveView = view
view.sequencer.prepareForPlaying()
view.sequencer.start()
