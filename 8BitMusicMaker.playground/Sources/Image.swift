import UIKit

public enum Image: String {
	case playButtonUp
	case playButtonDown
	case stopButtonUp
	case stopButtonDown
	case sequencerPointer
	case bitMusicMakerWP
}

extension UIImage {
	public convenience init(_ image: Image) {
		self.init(named: image.rawValue)!
	}

	public convenience init(note: Note) {
		self.init(named: "note" + note.name)!
	}
}
