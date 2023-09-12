import Foundation

enum colorSet {
    
    case normal
    case special
    case rare
    case elite
    
}

func generateRandomItemRarilty() -> colorSet {
    let randomValue = Int.random(in: 1...100)
    
    switch randomValue {
    case 1...60:
        return .normal
    case 61...90:
        return .special
    case 91...99:
        return .rare
    default:
        return .elite
    }
}
