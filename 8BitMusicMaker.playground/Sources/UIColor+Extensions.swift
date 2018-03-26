import UIKit

extension UIColor {
	public static let backgroundColor = #colorLiteral(red: 0.2467072606, green: 0.2543253303, blue: 0.2875217199, alpha: 1)
	public static let blockBackgroundColor = #colorLiteral(red: 0.1563676894, green: 0.1678637564, blue: 0.2093632221, alpha: 1)
	public static let pink = #colorLiteral(red: 0.9984274507, green: 0.2404478788, blue: 0.6934666634, alpha: 1)

	public static func colorFor(note: Note) -> UIColor {
		switch note {
		case .C2:
			return #colorLiteral(red: 0.1489660144, green: 0.4037302732, blue: 0.99575454, alpha: 1)
		case .D:
			return #colorLiteral(red: 0.1696922183, green: 0.5537169576, blue: 0.9980440736, alpha: 1)
		case .E:
			return #colorLiteral(red: 0.1213608906, green: 0.7254619002, blue: 0.9711827636, alpha: 1)
		case .F:
			return #colorLiteral(red: 0.444087863, green: 0.8653175235, blue: 0.9995786548, alpha: 1)
		case .G:
			return #colorLiteral(red: 0.444087863, green: 0.8653175235, blue: 0.9995786548, alpha: 1)
		case .A:
			return #colorLiteral(red: 0.7865936756, green: 0.9690931439, blue: 0.9825580716, alpha: 1)
		case .B:
			return #colorLiteral(red: 0.9825580716, green: 0.9437431083, blue: 0.8379510083, alpha: 1)
		case .C3:
			return #colorLiteral(red: 0.9825580716, green: 0.9437431083, blue: 0.3723542463, alpha: 1)
		}
	}
}
