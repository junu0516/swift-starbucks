import Foundation

struct HomeDataResponse: Codable {
    private (set) var displayName: String
    private var personalRecommendations: Recommendation
    private var mainEvent: MainEvent
    private var timeRecommendations: Recommendation
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display-name"
        case personalRecommendations = "your-recommand"
        case mainEvent = "main-event"
        case timeRecommendations = "now-recommand"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        displayName = (try? container.decode(String.self, forKey: .displayName)) ?? ""
        personalRecommendations = (try? container.decode(Recommendation.self, forKey: .personalRecommendations)) ?? Recommendation()
        timeRecommendations = (try? container.decode(Recommendation.self, forKey: .timeRecommendations)) ?? Recommendation()
        mainEvent = try container.decode(MainEvent.self, forKey: .mainEvent)
    }
}
