import Foundation

struct Recommendation: Codable {
    let products: [String]
    
    init() {
        self.products = []
    }
    
    init(products: [String]) {
        self.products = products
    }
}
