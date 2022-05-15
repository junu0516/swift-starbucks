import Foundation

struct ProductInfoRequest: Codable {
    let productCd: String
    
    enum CodingKeys: String, CodingKey {
        case productCd = "product_cd"
    }
}
