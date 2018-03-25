import PlaygroundSupport
import UIKit
import Foundation
import AVFoundation

class View: UIView {
	let sequencer = Sequencer(with: [.square, .triangle], initialState: [
			.square: [
	//			NoteAtBlock(note: .C2, block: 0),
	//			NoteAtBlock(note: .C2, block: 1),
	//			NoteAtBlock(note: .G, block: 2),
	//			NoteAtBlock(note: .G, block: 3),
	//			NoteAtBlock(note: .A, block: 4),
	//			NoteAtBlock(note: .A, block: 5),
	//			NoteAtBlock(note: .G, block: 6),

	//			NoteAtBlock(note: .F, block: 8),
	//			NoteAtBlock(note: .F, block: 9),
	//			NoteAtBlock(note: .E, block: 10),
	//			NoteAtBlock(note: .E, block: 11),
	//			NoteAtBlock(note: .D, block: 12),
	//			NoteAtBlock(note: .D, block: 13),
	//			NoteAtBlock(note: .C2, block: 14),
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


