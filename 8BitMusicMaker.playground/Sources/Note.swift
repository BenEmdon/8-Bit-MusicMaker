/// An enum that defines each notes pitch relative to the note C.
/// This assumes that the provided sound assets are a C note.
///
/// - C: Do
/// - D: Re
/// - E: Mi
/// - F: Fa
/// - G: Sol
/// - A: La
/// - B: Ti
public enum Note: Float {
	case C2 = 0
	case D = 10
	case E = 20
	case F = 25
	case G = 35
	case A = 45
	case B = 55
	case C3 = 60

	/// The `pitchModifier` is the amount by which the input signal (C note) is modified.
	public var pitchModifier: Float {
		return self.rawValue * 20
	}

	/// An array of all the cases.
	public static var allValues: [Note] {
		return [
			.C2,
			.D,
			.E,
			.F,
			.G,
			.A,
			.B,
			.C3,
		]
	}
}
