import PlaygroundSupport
import UIKit

class BitMusicMaker: UIView {
	let sequencer: Sequencer
	let blocks: Int
	let instriments: [Instrument]
	let sequencerViews: [Instrument: SequencerView]

	init(with instruments: [Instrument], initialState state: [Instrument: Set<NoteAtBlock>], numberOfBlocks blocks: Int) {
		self.instriments = instruments
		self.blocks = blocks
		sequencer = Sequencer(with: instruments, initialState: state, numberOfBlocks: blocks)

		let sequencerViewsWidth = CGFloat(blocks + 1) * Metrics.blockSize
		let sequencerViewsHeight = CGFloat(Note.allValues.count + 1) * Metrics.blockSize

		var sequencerViews = [Instrument: SequencerView]()
		instruments.forEach { instrument in
			sequencerViews[instrument] = SequencerView(instrument: instrument, blocks: blocks)
		}
		self.sequencerViews = sequencerViews

		let width = sequencerViewsWidth + Metrics.blockSize * 2
		let height = sequencerViewsHeight * CGFloat(sequencerViews.count) + CGFloat(sequencerViews.count + 1) * Metrics.blockSize

		super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
		setupViews(sequencerViewsWidth: sequencerViewsWidth, sequencerViewsHeight: sequencerViewsHeight)
		sequencer.delegate = self
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		sequencer.prepareForPlaying()
		sequencer.start()
	}

	func setupViews(sequencerViewsWidth: CGFloat, sequencerViewsHeight: CGFloat) {
		backgroundColor = .gray

		let stackView = UIStackView(arrangedSubviews: Array(sequencerViews.values))
		stackView.frame = CGRect(
			x: Metrics.blockSize,
			y: Metrics.blockSize,
			width: sequencerViewsWidth,
			height: sequencerViewsHeight * CGFloat(sequencerViews.count) + CGFloat(sequencerViews.count - 1) * Metrics.blockSize
		)
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = Metrics.blockSize

		addSubview(stackView)

		sequencerViews
	}
}

extension BitMusicMaker: SequencerDelegate {
	public func blockChanged(_ block: Int) {
		// render sequencerViews currentBlock
	}

	public func sequencerModeChanged(_ mode: Sequencer.Mode) {
		// change play/stop button
	}

	public func stateChanged(_ state: [Instrument : Set<NoteAtBlock>]) {
		// render sequenceViews (do diff)
		for (instrument, state) in state {
			sequencerViews[instrument]?.highlightNotes(newState: state)
		}
	}
}

protocol SequencerViewDelegate: class {
	func noteDrawn(note: Note, block: Int, instrument: Instrument)
}

class SequencerView: UIView {
	typealias BlockView = UIView

	let blocks: Int
	let instrument: Instrument
	var localState = Set<NoteAtBlock>()
	let blockViews: Array<Array<BlockView>>

	weak var delegate: SequencerViewDelegate?

	let defaultBlockColor = UIColor.darkGray
	let highlightedBlockColor = UIColor.red
	let blockBorderWidth: CGFloat = 0.5

	init(instrument: Instrument, blocks: Int) {
		self.blocks = blocks
		self.instrument = instrument

		var blockViews = Array<Array<BlockView>>()
		for noteIndex in 0..<Note.allValues.count {
			blockViews.append([])
			for blockIndex in 0..<blocks {
				let blockView = SequencerView.createBlockView(defaultColor: defaultBlockColor, blockBorderWidth: blockBorderWidth)
				blockView.frame = CGRect(
					x: CGFloat(blockIndex) * Metrics.blockSize + Metrics.blockSize,
					y: CGFloat(noteIndex) * Metrics.blockSize + Metrics.blockSize,
					width: Metrics.blockSize,
					height: Metrics.blockSize
				)
				blockViews[noteIndex].append(blockView)
			}
		}
		self.blockViews = blockViews

		super.init(frame: CGRect(
			x: 0,
			y: 0,
			width: Metrics.blockSize * CGFloat(blocks + 1),
			height: Metrics.blockSize * CGFloat(Note.allValues.count + 1)
		))
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private static func createBlockView(defaultColor: UIColor, blockBorderWidth: CGFloat) -> BlockView {
		let blockView = BlockView()
		blockView.backgroundColor = defaultColor
		blockView.layer.borderWidth = blockBorderWidth
		blockView.layer.borderColor = UIColor.lightGray.cgColor
		blockView.isUserInteractionEnabled = false
		return blockView
	}

	func setupViews() {
		isUserInteractionEnabled = true

		for blockRow in blockViews {
			for blockView in blockRow {
				addSubview(blockView)
			}
		}

		let dragGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleDrag(sender:)))
		dragGestureRecognizer.minimumPressDuration = 0
		addGestureRecognizer(dragGestureRecognizer)

		// setup more views
	}

	func highlightNotes(newState: Set<NoteAtBlock>) {
		let notesToClear = localState.subtracting(newState)
		let notesToHighlight = newState.subtracting(localState)
		for noteToClear in notesToClear {
			let noteIndex = Note.allValues.index(of: noteToClear.note)!
			blockViews[noteIndex][noteToClear.block].backgroundColor = defaultBlockColor
		}
		for noteToHighlight in notesToHighlight {
			let noteIndex = Note.allValues.index(of: noteToHighlight.note)!
			blockViews[noteIndex][noteToHighlight.block].backgroundColor = highlightedBlockColor
		}
		localState = newState
	}

	@objc func handleDrag(sender: UIGestureRecognizer) {
		switch sender.state {
		case .began, .changed, .ended:
			let point = sender.location(in: self)
			guard point.x - Metrics.blockSize > 0 && point.y - Metrics.blockSize > 0 else { return }
			let noteIndex = Int((point.y - Metrics.blockSize) / Metrics.blockSize)
			let blockIndex = Int((point.x - Metrics.blockSize) / Metrics.blockSize)
			guard let firstBlockRow = blockViews.first, noteIndex < blockViews.count && blockIndex < firstBlockRow.count else { return }
			delegate?.noteDrawn(note: Note.allValues[noteIndex], block: blockIndex, instrument: instrument)
		default: break
		}
	}
}

let bitMusicMaker = BitMusicMaker(
	with: [.triangle, .square],
	initialState: [
		.square: [
			NoteAtBlock(note: .C2, block: 0),
			NoteAtBlock(note: .C2, block: 1),
			NoteAtBlock(note: .G, block: 2),
			NoteAtBlock(note: .G, block: 3),
			NoteAtBlock(note: .A, block: 4),
			NoteAtBlock(note: .A, block: 5),
			NoteAtBlock(note: .G, block: 6),

			NoteAtBlock(note: .F, block: 8),
			NoteAtBlock(note: .F, block: 9),
			NoteAtBlock(note: .E, block: 10),
			NoteAtBlock(note: .E, block: 11),
			NoteAtBlock(note: .D, block: 12),
			NoteAtBlock(note: .D, block: 13),
			NoteAtBlock(note: .C2, block: 14),
		],
		.triangle: [
			NoteAtBlock(note: .C2, block: 0),
			NoteAtBlock(note: .C2, block: 1),
			NoteAtBlock(note: .G, block: 2),
			NoteAtBlock(note: .G, block: 3),
			NoteAtBlock(note: .A, block: 4),
			NoteAtBlock(note: .A, block: 5),
			NoteAtBlock(note: .G, block: 6),

			NoteAtBlock(note: .F, block: 8),
			NoteAtBlock(note: .F, block: 9),
			NoteAtBlock(note: .E, block: 10),
			NoteAtBlock(note: .E, block: 11),
			NoteAtBlock(note: .D, block: 12),
			NoteAtBlock(note: .D, block: 13),
			NoteAtBlock(note: .C2, block: 14),
		]
	],
	numberOfBlocks: 16
)
PlaygroundPage.current.liveView = bitMusicMaker


