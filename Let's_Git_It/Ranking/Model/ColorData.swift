import Foundation
import UIKit
enum ItemType {
    
    case basic
    case normal
    case special
    case rare
    case elite
    
    
}
let itemsColors : [ItemType : [String]] = [
    .basic: ["161C22","114429","216D32","37A641","48D353"],
    .normal: ["161C22","B5BAF3","7A83EA","4E5AE3","2332DB"],
    .special: ["161C22","F9D2BB","F5B38C","F0945E","EC752F"],
    .rare: ["161C22","F1A2AF","EA7689","E34A64","D92140"],
    .elite: ["161C22","B4EEFF","F3BE4C","FF7D93","BA6BC7"],
]
func generateRandomItemRarilty() -> ItemType {
    let randomValue = Int.random(in: 1...100)
    
    switch randomValue {
    case 1...60:
        return .normal
    case 61...90:
        return .special
    case 91...99:
        return .rare
    case 100:
        return .elite
    default:
        return .basic
    }
}


func hexStringToUIColor(_ hex: String) -> UIColor? {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    //hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

    var rgb: UInt64 = 0

    Scanner(string: hexSanitized).scanHexInt64(&rgb)

    let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgb & 0x0000FF) / 255.0

    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}

