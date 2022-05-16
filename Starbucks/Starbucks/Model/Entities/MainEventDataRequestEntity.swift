import Foundation

struct MainEventDataRequestEntity: Codable {
    private (set) var imageUrl: String = ""
    private (set) var imageFileName: String = ""
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "img_UPLOAD_PATH"
        case imageFileName = "mob_THUM"
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        imageFileName = try container.decode(String.self, forKey: .imageFileName)
    }
}
