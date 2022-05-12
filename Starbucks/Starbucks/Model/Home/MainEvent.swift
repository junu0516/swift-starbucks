import Foundation

struct MainEvent: Codable {
    private var imageUrl: String
    private var imageFileName: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "img_UPLOAD_PATH"
        case imageFileName = "mob_THUM"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        imageFileName = try container.decode(String.self, forKey: .imageFileName)
    }
}
