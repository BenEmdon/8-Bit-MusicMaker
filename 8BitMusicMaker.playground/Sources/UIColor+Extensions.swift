import UIKit

extension UIColor {
	public static let backgroundColor = #colorLiteral(red: 0.1746234079, green: 0.1746234079, blue: 0.1746234079, alpha: 1)
	public static let blockBackgroundColor = #colorLiteral(red: 0.352899313, green: 0.3529652655, blue: 0.3528951406, alpha: 1)
	public static let pink = #colorLiteral(red: 0.9984274507, green: 0.2404478788, blue: 0.6934666634, alpha: 1)

	public static func colorFor(note: Note) -> UIColor {
		switch note {
		case .C3:
			return #colorLiteral(red: 0.1489660144, green: 0.4037302732, blue: 0.99575454, alpha: 1)
		case .B:
			return #colorLiteral(red: 0.1696922183, green: 0.5537169576, blue: 0.9980440736, alpha: 1)
		case .A:
			return #colorLiteral(red: 0.1213608906, green: 0.7254619002, blue: 0.9711827636, alpha: 1)
		case .G:
			return #colorLiteral(red: 0.444087863, green: 0.8653175235, blue: 0.9995786548, alpha: 1)
		case .F:
			return #colorLiteral(red: 0.444087863, green: 0.8653175235, blue: 0.9995786548, alpha: 1)
		case .E:
			return #colorLiteral(red: 0.7865936756, green: 0.9690931439, blue: 0.9825580716, alpha: 1)
		case .D:
			return #colorLiteral(red: 0.9825580716, green: 0.9437431083, blue: 0.8379510083, alpha: 1)
		case .C2:
			return #colorLiteral(red: 0.9825580716, green: 0.9437431083, blue: 0.3723542463, alpha: 1)
		}
	}
}
