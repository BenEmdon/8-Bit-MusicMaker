/// An enum that defines each notes pitch relative to the note C2.
/// This assumes that the provided sound assets are a C2 note.
/// A full octive is 1200 times the pitch.
///
/// - C: Do
/// - D: Re
/// - E: Mi
/// - F: Fa
/// - G: Sol
/// - A: La
/// - B: Ti
/// - C2: Do
public enum Note: Float {
	case C = 0
	case D = 10
	case E = 20
	case F = 25
	case G = 35
	case A = 45
	case B = 55
	case C2 = 60

	/// The `pitchModifier` is the amount by which the input signal (C note) is modified.
	public var pitchModifier: Float {
		return self.rawValue * 20
	}

	/// An array of all the cases.
	public static var allValues: [Note] {
		return [
			.C2,
			.B,
			.A,
			.G,
			.F,
			.E,
			.D,
			.C
		]
	}

	/// String name identifying the note.
	var name: String {
		switch self {
		case .A:
			return "A"
		case .B:
			return "B"
		case .C, .C2:
			return "C"
		case .D:
			return "D"
		case .E:
			return "E"
		case .F:
			return "F"
		case .G:
			return "G"
		}
	}
}
