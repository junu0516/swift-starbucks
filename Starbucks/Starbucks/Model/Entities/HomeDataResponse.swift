import Foundation

struct HomeDataResponse: Codable {
    private (set) var displayName: String
    private (set) var personalRecommendations: RecommendedProductIdListEntity
    private (set) var mainEvent: MainEventDataRequestEntity
    private (set) var timeRecommendations: RecommendedProductIdListEntity
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display-name"
        case personalRecommendations = "your-recommand"
        case mainEvent = "main-event"
        case timeRecommendations = "now-recommand"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        displayName = (try? container.decode(String.self, forKey: .displayName)) ?? ""
        personalRecommendations = (try? container.decode(RecommendedProductIdListEntity.self, forKey: .personalRecommendations)) ?? RecommendedProductIdListEntity()
        timeRecommendations = (try? container.decode(RecommendedProductIdListEntity.self, forKey: .timeRecommendations)) ?? RecommendedProductIdListEntity()
        mainEvent = try container.decode(MainEventDataRequestEntity.self, forKey: .mainEvent)
    }
}
