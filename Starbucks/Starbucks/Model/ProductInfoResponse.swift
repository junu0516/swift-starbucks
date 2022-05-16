import Foundation

struct ProductInfoResponse: Decodable {
    private (set) var content: String
    private (set) var productName: String
    private (set) var recommend: String
    
    enum CodingKeys: String, CodingKey {
        case content = "content"
        case productName = "product_NM"
        case recommend = "recommend"
        case view
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .view)
        self.content = try nestedContainer.decode(String.self, forKey: .content)
        self.productName = try nestedContainer.decode(String.self, forKey: .productName)
        self.recommend = try nestedContainer.decode(String.self, forKey: .recommend)
    }
}
