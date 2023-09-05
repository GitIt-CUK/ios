import UIKit
class CommitCell: UICollectionViewCell {
    
    var commitData: CommitData? {
        didSet {
            guard let commitCount = commitData?.commitCount else {
                backgroundColor = UIColor.clear
                return
            }

            switch commitCount {
            case 1:
                backgroundColor = UIColor(hex: "#114429")
            case 2:
                backgroundColor = UIColor(hex: "#216D32")
            case 3:
                backgroundColor = UIColor(hex: "#37A641")
            case 4...:
                backgroundColor = UIColor(hex: "#48D353")
            default:
                backgroundColor = UIColor(hex: "#161C22")            }
        }
    }
}

// UIColor 확장을 통해 Hex 문자열을 UIColor로 변환
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(alpha))
    }
}
