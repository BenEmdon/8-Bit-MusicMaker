import Foundation

/// Each instriment is a sample of a different 8-bit wave form.
/// All samples are each wave form as a C2 note.
///
/// - square: square wave form.
/// - triangle: traingle wave from.
/// - noise: noisy wave. Imagine a ragged mountain surface.
enum Instrument: String {
	case square
	case triangle
	case noise
}
