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
	case D2 = 70
	case E2 = 80
	case F2 = 85
	case G2 = 95
	case A2 = 105
	case B2 = 115
	case C3 = 120

	public enum NumberOfOctaves {
		case one
		case two
	}

	internal static var numberOfOctaves: NumberOfOctaves = .one

	/// The `pitchModifier` is the amount by which the input signal (C note) is modified.
	public var pitchModifier: Float {
		return self.rawValue * 20
	}
	/// An array of all the cases.

	public static var allValues: [Note] {
		switch Note.numberOfOctaves {
		case .one:
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
		case .two:
			return [
				.C3,
				.B2,
				.A2,
				.G2,
				.F2,
				.E2,
				.D2,
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

	}

	/// String name identifying the note.
	var name: String {
		switch self {
		case .A, .A2:
			return "A"
		case .B, .B2:
			return "B"
		case .C, .C2, .C3:
			return "C"
		case .D, .D2:
			return "D"
		case .E, .E2:
			return "E"
		case .F, .F2:
			return "F"
		case .G, .G2:
			return "G"
		}
	}
}
