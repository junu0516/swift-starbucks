import Foundation

final class RecommendationViewModel {
    
    private var networkHandler: NetworkHandlable?

    init(networkHandler: NetworkHandlable) {
        self.networkHandler = networkHandler
    }
}
