import UIKit

public enum Image: String {
	case playButtonUp
	case playButtonDown
	case stopButtonUp
	case stopButtonDown
	case sequencerPointer
	case bitMusicMakerWP
	case recordButtonUp0
	case recordButtonUp1
	case recordButtonUp2
	case recordButtonUp3
	case recordButtonDown
}

extension UIImage {
	public convenience init(_ image: Image) {
		self.init(named: image.rawValue)!
	}

	public convenience init(note: Note) {
		self.init(named: "note" + note.name)!
	}

	public convenience init(instrumentForWave instrument: Instrument) {
		self.init(named: instrument.rawValue + "Wave")!
	}

	public convenience init(instrumentForTitle instrument: Instrument) {
		self.init(named: instrument.rawValue + "Title")!
	}

	public static var recordingButton: UIImage {
		return UIImage.animatedImage(with: [
			UIImage(.recordButtonUp0),
			UIImage(.recordButtonUp1),
			UIImage(.recordButtonUp2),
			UIImage(.recordButtonUp3),
			UIImage(.recordButtonUp2),
			UIImage(.recordButtonUp1),
			], duration: 1)!
	}
}
