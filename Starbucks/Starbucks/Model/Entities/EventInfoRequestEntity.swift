import Foundation

struct EventInfoRequestEntity: Encodable {
    private let menuCd: String = "all"
    
    enum CodingKeys: String, CodingKey {
        case menuCd = "MENU_CD"
    }
}
