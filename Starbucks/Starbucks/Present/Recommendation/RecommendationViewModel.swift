import Foundation

final class RecommendationViewModel {
    
    private (set) var recommendations = Observable<[Data]>([])
    private var networkHandler: NetworkHandlable?

    init(networkHandler: NetworkHandlable) {
        self.networkHandler = networkHandler
    }
}
