import PlaygroundSupport
import UIKit

class BitMusicMaker: UIView {
	let sequencer: Sequencer
	let blocks: Int
	let instriments: [Instrument]
	let sequencerViews: [Instrument: SequencerView]
	let logo = UIImage(.bitMusicMakerWP)
	let playStopButton: UIButton

	init(with instruments: [Instrument], initialState state: [Instrument: Set<NoteAtBlock>], numberOfBlocks blocks: Int) {
		// setup state
		self.instriments = instruments
		self.blocks = blocks
		sequencer = Sequencer(with: instruments, initialState: state, numberOfBlocks: blocks)

		// determine sequencerViews width/height
		let sequencerViewsWidth = CGFloat(blocks + 1) * Metrics.blockSize
		let sequencerViewsHeight = CGFloat(Note.allValues.count + 1) * Metrics.blockSize

		// create sequencerViews
		var sequencerViews = [Instrument: SequencerView]()
		instruments.forEach { instrument in
			sequencerViews[instrument] = SequencerView(instrument: instrument, blocks: blocks)
		}
		self.sequencerViews = sequencerViews

		// create play/stop button
		playStopButton = UIButton(frame: CGRect(
			x: logo.size.width + Metrics.blockSize * 2,
			y: Metrics.blockSize,
			width: Metrics.blockSize * 4,
			height: Metrics.blockSize * 4
		))

		// determine width and height of self
		let width = max(sequencerViewsWidth + Metrics.blockSize * 2, Metrics.blockSize * 3 + logo.size.width + playStopButton.frame.size.width)
		let height = sequencerViewsHeight * CGFloat(sequencerViews.count) + CGFloat(sequencerViews.count + 1) * Metrics.blockSize + logo.size.height

		super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
		setupViews(sequencerViewsWidth: sequencerViewsWidth, sequencerViewsHeight: sequencerViewsHeight)
		sequencer.delegate = self
		for (_, sequencerView) in sequencerViews {
			sequencerView.delegate = self
		}
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
		backgroundColor = .backgroundColor

		let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: Metrics.blockSize, y: 0), size: logo.size))
		imageView.contentMode = .scaleAspectFill
		imageView.image = logo
		addSubview(imageView)

		playStopButton.setImage(UIImage(.playButtonUp), for: .normal)
		playStopButton.setImage(UIImage(.playButtonDown), for: .highlighted)
		addSubview(playStopButton)
		playStopButton.addTarget(self, action: #selector(handlePlayStopTouch), for: .touchUpInside)

		let stackView = UIStackView(arrangedSubviews: Array(sequencerViews.values))
		stackView.frame = CGRect(
			x: Metrics.blockSize,
			y: Metrics.blockSize + logo.size.height,
			width: sequencerViewsWidth,
			height: sequencerViewsHeight * CGFloat(sequencerViews.count) + CGFloat(sequencerViews.count - 1) * Metrics.blockSize
		)
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = Metrics.blockSize

		addSubview(stackView)

		sequencerViews
	}

	@objc func handlePlayStopTouch() {
		switch sequencer.currentMode {
		case .playing:
			sequencer.hardStop()
		case .stopped:
			sequencer.start()
		}
	}
}

extension BitMusicMaker: SequencerDelegate {
	public func blockChanged(_ block: Int) {
		// render sequencerViews currentBlock
		for (_, sequencerView) in sequencerViews {
			sequencerView.pointToBlock(block)
		}
	}

	public func sequencerModeChanged(_ mode: Sequencer.Mode) {
		// change play/stop button
		switch mode {
		case .playing:
			playStopButton.setImage(UIImage(.stopButtonUp), for: .normal)
			playStopButton.setImage(UIImage(.stopButtonDown), for: .highlighted)
		case .stopped:
			playStopButton.setImage(UIImage(.playButtonUp), for: .normal)
			playStopButton.setImage(UIImage(.playButtonDown), for: .highlighted)
		}
		sequencerViews.forEach { (_, sequencerView) in
			sequencerView.sequencerMode = mode
		}
	}

	public func stateChanged(_ state: [Instrument : Set<NoteAtBlock>]) {
		// render sequenceViews (do diff)
		for (instrument, state) in state {
			sequencerViews[instrument]?.highlightNotes(newState: state)
		}
	}
}

extension BitMusicMaker: SequencerViewDelegate {
	func noteDrawn(note: Note, block: Int, instrument: Instrument) {
		sequencer.toggleNote(note, onInstrument: instrument, forBlock: block)
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
		]
	],
	numberOfBlocks: 20
)
PlaygroundPage.current.liveView = bitMusicMaker


