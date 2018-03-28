import UIKit

protocol SequencerViewDelegate: class {
	func noteDrawn(note: Note, block: Int, instrument: Instrument)
}

class SequencerView: UIView {
	typealias BlockView = UIView

	let blocks: Int
	let instrument: Instrument
	var localState = Set<NoteAtBlock>()
	let blockViews: Array<Array<BlockView>>
	let blockPointer: UIView
	var sequencerMode: Sequencer.Mode = .stopped

	weak var delegate: SequencerViewDelegate?

	let defaultBlockColor = UIColor.blockBackgroundColor
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

		blockPointer = UIView(frame: CGRect(
			x: Metrics.blockSize,
			y: 0,
			width: Metrics.blockSize,
			height: Metrics.blockSize * CGFloat(Note.allValues.count + 1)
		))

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
		blockView.layer.borderColor = UIColor.white.cgColor
		blockView.isUserInteractionEnabled = false
		return blockView
	}

	func setupViews() {
		isUserInteractionEnabled = true

		for (index, note) in Note.allValues.enumerated() {
			let imageView = UIImageView(frame: CGRect(
				x: 0,
				y: CGFloat(index) * Metrics.blockSize + Metrics.blockSize,
				width: Metrics.blockSize,
				height: Metrics.blockSize
			))
			imageView.image = UIImage(note: note)
			addSubview(imageView)
		}

		for blockRow in blockViews {
			for blockView in blockRow {
				addSubview(blockView)
			}
		}

		let dragGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTouch(sender:)))
		addGestureRecognizer(dragGestureRecognizer)

		blockPointer.backgroundColor = UIColor.white.withAlphaComponent(0.2)
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Metrics.blockSize, height: Metrics.blockSize))
		imageView.image = UIImage(Image.sequencerPointer)
		blockPointer.contentMode = .scaleAspectFit
		blockPointer.addSubview(imageView)
		addSubview(blockPointer)
	}

	func highlightNotes(newState: Set<NoteAtBlock>) {
		let notesToClear = localState.subtracting(newState)
		let notesToHighlight = newState.subtracting(localState)
		for noteToClear in notesToClear {
			if let noteIndex = Note.allValues.index(of: noteToClear.note) {
				blockViews[noteIndex][noteToClear.block].backgroundColor = defaultBlockColor
			}
		}
		for noteToHighlight in notesToHighlight {
			if let noteIndex = Note.allValues.index(of: noteToHighlight.note) {
				blockViews[noteIndex][noteToHighlight.block].backgroundColor = UIColor.colorFor(note: noteToHighlight.note)
			}
		}
		localState = newState
	}

	@objc func handleTouch(sender: UIGestureRecognizer) {
		let point = sender.location(in: self)
		guard point.x - Metrics.blockSize > 0 && point.y - Metrics.blockSize > 0 else { return }
		guard !blockPointer.frame.contains(point) || sequencerMode == .stopped else { return }
		let noteIndex = Int((point.y - Metrics.blockSize) / Metrics.blockSize)
		let blockIndex = Int((point.x - Metrics.blockSize) / Metrics.blockSize)
		guard let firstBlockRow = blockViews.first, noteIndex < blockViews.count && blockIndex < firstBlockRow.count else { return }
		delegate?.noteDrawn(note: Note.allValues[noteIndex], block: blockIndex, instrument: instrument)
	}

	func pointToBlock(_ block: Int) {
		UIView.animate(withDuration: 0.1) { [weak self] in
			self?.blockPointer.frame.origin.x = CGFloat(block) * Metrics.blockSize + Metrics.blockSize
		}
	}
}
