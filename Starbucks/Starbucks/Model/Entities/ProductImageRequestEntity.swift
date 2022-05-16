import Foundation

struct ProductImageRequestEntity: Codable {
    let productCd: String
    
    enum CodingKeys: String, CodingKey {
        case productCd = "PRODUCT_CD"
    }
}
