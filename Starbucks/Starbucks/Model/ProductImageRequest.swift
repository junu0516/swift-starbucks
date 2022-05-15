import Foundation

struct ProductImageRequest: Codable {
    let productCd: String
    
    enum CodingKeys: String, CodingKey {
        case productCd = "PRODUCT_CD"
    }
}
