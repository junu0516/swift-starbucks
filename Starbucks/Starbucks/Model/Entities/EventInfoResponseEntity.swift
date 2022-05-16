import Foundation

struct EventInfoResponseEntityList: Decodable {
    private let list: [EventInfoResponseEntity]
}

struct EventInfoResponseEntity: Decodable {
    private (set) var eventTitle: String
    private (set) var eventSubTitle: String
    private (set) var imageFileRequestEntity: EventImageRequestEntity
    
    enum CodingKeys: String, CodingKey {
        case eventTitle = "title"
        case eventSubTitle = "sbtitle_NAME"
        case imageUrl = "img_UPLOAD_PATH"
        case imageFileName = "mob_THUM"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.eventTitle = try container.decode(String.self, forKey: .eventTitle)
        self.eventSubTitle = try container.decode(String.self, forKey: .eventSubTitle)
        
        let imageUrl = try container.decode(String.self, forKey: .imageUrl)
        let imageFileName = try container.decode(String.self, forKey: .imageFileName)
        self.imageFileRequestEntity = EventImageRequestEntity(imageUrl: imageUrl, imageFileName: imageFileName)
    }
}

