import Foundation
import AVFoundation

/// Each instriment is a sample of a different 8-bit wave form.
/// All samples are each wave form as a C2 note.
///
/// - square: square wave form.
/// - triangle: traingle wave from.
/// - noise: noisy wave. Imagine a ragged mountain surface.
public enum Instrument: String {
	case square
	case triangle
	case noise

	public var sample: AVAudioFile {
		let url = Bundle.main.url(forResource: "8-bit-" + rawValue, withExtension: "m4a")!
		return try! AVAudioFile(forReading: url)
	}
}
