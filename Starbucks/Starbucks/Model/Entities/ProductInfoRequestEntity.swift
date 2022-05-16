import Foundation

struct ProductInfoRequestEntity: Codable {
    let productCd: String
    
    enum CodingKeys: String, CodingKey {
        case productCd = "product_cd"
    }
}
