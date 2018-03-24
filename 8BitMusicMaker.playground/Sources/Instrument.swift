import Foundation
import AVFoundation

/// Each instriment is a sample of a different 8-bit wave form.
/// All samples are of a C note.
///
/// - square: Square wave form.
/// - triangle: Traingle wave from.
/// - noise: Noisy wave form. Imagine the outline of a ragged mountain.
public enum Instrument: String {
	case square
	case triangle
	case noise

	/// An audio file of an instrument playing a C.
	/// Assumes the audio file is in the project bundle.
	public var sample: AVAudioFile {
		let url = Bundle.main.url(forResource: "8-bit-" + rawValue, withExtension: "m4a")!
		return try! AVAudioFile(forReading: url)
	}
}
