import PlaygroundSupport
import UIKit

class BitMusicMaker: UIView {
	let sequencer: Sequencer
	let blocks: Int
	let instriments: [Instrument]
	let sequencerViews: [SequenceView]

	init(with instruments: [Instrument], initialState state: [Instrument: Set<NoteAtBlock>], numberOfBlocks blocks: Int) {
		self.instriments = instruments
		self.blocks = blocks
		sequencer = Sequencer(with: instruments, initialState: state, numberOfBlocks: blocks)

		let sequencerViewsWidth = CGFloat(blocks + 1) * Metrics.blockSize
		let sequencerViewsHeight = CGFloat(Note.allValues.count + 1) * Metrics.blockSize
		sequencerViews = instruments.map { instrument in
			return SequenceView(instrument: instrument, blocks: blocks, initialState: state[instrument])
		}

		let width = sequencerViewsWidth + Metrics.blockSize * 2
		let height = sequencerViewsHeight * CGFloat(sequencerViews.count) + CGFloat(sequencerViews.count + 1) * Metrics.blockSize

		super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
		setupViews(sequencerViewsWidth: sequencerViewsWidth, sequencerViewsHeight: sequencerViewsHeight)
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

		let stackView = UIStackView(arrangedSubviews: sequencerViews)
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
	}
}

class SequenceView: UIView {
	typealias BlockView = UIView

	let blocks: Int
	let instrument: Instrument
	var localState: Set<NoteAtBlock>
	let blockViews: Array<Array<BlockView>>

	let defaultBlockColor = UIColor.darkGray
	let highlightedBlockColor = UIColor.red
	let blockBorderWidth: CGFloat = 0.5

	init(instrument: Instrument, blocks: Int, initialState state: Set<NoteAtBlock>?) {
		self.blocks = blocks
		self.instrument = instrument
		localState = state ?? []

		var blockViews = Array<Array<BlockView>>()
		for heightIndex in 0..<Note.allValues.count {
			blockViews.append([])
			for widthIndex in 0..<blocks {
				let blockView = SequenceView.createBlockView(defaultColor: defaultBlockColor, blockBorderWidth: blockBorderWidth)
				blockView.frame = CGRect(
					x: CGFloat(widthIndex) * Metrics.blockSize + Metrics.blockSize,
					y: CGFloat(heightIndex) * Metrics.blockSize + Metrics.blockSize,
					width: Metrics.blockSize,
					height: Metrics.blockSize
				)
				blockViews[heightIndex].append(blockView)
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

		for row in blockViews {
			for blockView in row {
				addSubview(blockView)
			}
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
		]
	],
	numberOfBlocks: 16
)
PlaygroundPage.current.liveView = bitMusicMaker


