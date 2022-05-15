import Foundation

struct ImageFileRequestList: Codable {
    private (set) var file: [ImageFileRequest]
}

struct ImageFileRequest: Codable {
    private (set) var filePath: String
    private (set) var fileUrl: String
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_PATH"
        case fileUrl = "img_UPLOAD_PATH"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.filePath = try container.decode(String.self, forKey: .filePath)
        self.fileUrl = try container.decode(String.self, forKey: .fileUrl)
    }
}
