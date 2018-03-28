import UIKit

/// Image is an enum providing force unwrapped assets that are assumed to be present.
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
	/// Convenience initializer for te Image enum.
	public convenience init(_ image: Image) {
		self.init(named: image.rawValue)!
	}

	convenience init(note: Note) {
		self.init(named: "note" + note.name)!
	}

	/// Conconvenience initializer for the wave image assets.
	///
	/// - Parameter instrument: <#instrument description#>
	public convenience init(instrumentForWave instrument: Instrument) {
		self.init(named: instrument.rawValue + "Wave")!
	}

	convenience init(instrumentForTitle instrument: Instrument) {
		self.init(named: instrument.rawValue + "Title")!
	}

	/// The animated recording button image.
	public static var recordingButton: UIImage {
		return UIImage.animatedImage(
			with: [
				UIImage(.recordButtonUp0),
				UIImage(.recordButtonUp1),
				UIImage(.recordButtonUp2),
				UIImage(.recordButtonUp3),
				UIImage(.recordButtonUp2),
				UIImage(.recordButtonUp1),
			],
			duration: 1
		)!
	}
}
