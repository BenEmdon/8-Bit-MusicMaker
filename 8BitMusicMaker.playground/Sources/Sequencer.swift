import AVFoundation
import Foundation

public struct NoteAtBlock {
	public let note: Note
	public let block: Int
	
	public init(note: Note, block: Int) {
		self.note = note
		self.block = block
	}
}

extension NoteAtBlock: Hashable {
	public static func ==(lhs: NoteAtBlock, rhs: NoteAtBlock) -> Bool {
		return lhs.block == rhs.block
			&& lhs.note == rhs.note
	}

	public var hashValue: Int {
		return "\(note.rawValue).\(block)".hashValue
	}
}

public protocol SequencerDelegate: class {
	func blockChanged(_ block: Int)
	func sequencerModeChanged(_ mode: Sequencer.Mode)
	func stateChanged(_ state: [Instrument: Set<NoteAtBlock>])
}

public class Sequencer {

	public enum Mode {
		case playing
		case stopped
	}

	// Constants
	let blocks: Int

	//	let blocksPerSecond: DispatchTime = 0.5

	// AVFoundation dependancies
	private let engine = AVAudioEngine()

	// Organized state of the sequencer
	private let players: [Instrument: [Note: PitchedPlayer]]
	public private(set) var notesAtBlocks: [Instrument: Set<NoteAtBlock>]
	public private(set) var currentMode: Mode = .stopped

	public weak var delegate: SequencerDelegate?

	public init(with instruments: [Instrument], initialState state: [Instrument: Set<NoteAtBlock>] = [:], numberOfBlocks blocks: Int) {
		let buffers = Sequencer.audioBuffers(for: instruments)
		players = Sequencer.createPlayers(forBuffers: buffers, engine: engine)
		notesAtBlocks = state
		self.blocks = blocks
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

	public func prepareForPlaying() {
		engine.prepare()
		try! engine.start()
		delegate?.stateChanged(notesAtBlocks)
	}

	public func hardStop() {
		currentMode = .stopped
		for (instrument, notesAtBlocks) in notesAtBlocks {
			let notesInBlock = notesAtBlocks
				.map { noteAtBlock in noteAtBlock.note }
			print(notesInBlock)
			notesInBlock.forEach { note in stopNote(note, onInstrument: instrument) }
		}
		delegate?.sequencerModeChanged(currentMode)
		delegate?.blockChanged(0)
	}

	public func start() {
		currentMode = .playing
		delegate?.sequencerModeChanged(currentMode)
		sequenceNotes(forNewBlock: 0, oldBlock: nil)
	}

	private func sequenceNotes(forNewBlock newBlock: Int, oldBlock: Int?) {
		if let oldBlock = oldBlock {
			stopNotesForBlock(oldBlock)
		}
		guard currentMode == .playing else { return }
		delegate?.blockChanged(newBlock)
		playNotesForBlock(newBlock)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
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

	public func registerNote(_ note: Note, onInstrument instrument: Instrument, forBlock block: Int) {
		notesAtBlocks[instrument]?.insert(NoteAtBlock(note: note, block: block))
		delegate?.stateChanged(notesAtBlocks)
	}

	public func deregisterNote(_ note: Note, onInstrument instrument: Instrument, forBlock block: Int) {
		if let _ = notesAtBlocks[instrument]?.remove(NoteAtBlock(note: note, block: block)) {
			delegate?.stateChanged(notesAtBlocks)
		}
	}

	private func playNote(_ note: Note, onInstrument instrument: Instrument) {
		// simple play a note
		players[instrument]![note]!.play()
	}

	private func stopNote(_ note: Note, onInstrument instrument: Instrument) {
		// simple play a note
		players[instrument]![note]!.stop()
	}
}
