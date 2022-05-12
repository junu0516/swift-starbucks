import Foundation
import OSLog

final class HomeViewModel {
    
    private (set) var mainEvent = Observable<MainEvent>(MainEvent())
    private (set) var eventImageData = Observable<Data>(Data())
    private (set) var displayName = Observable<String>("USER NAME")
    private (set) var personalRecommendations = Observable<[Recommendation]>([])
    private (set) var timeRecommendations = Observable<[Recommendation]>([])

    private var networkHandler: NetworkHandlable?
    private var jsonHandler: JSONHandlable = JSONHandler()
    private let logger = Logger()
    
    init(networkHandler: NetworkHandlable) {
        self.networkHandler = networkHandler
        loadUserData()
    }
    
    func loadUserData() {
        sendApiRequest(url: .homeData, method: .get, contentType: .json) { [weak self] data in
            guard let response = self?.jsonHandler.convertJSONToObject(from: data, to: HomeDataResponse.self) else { return }
            self?.displayName.value = response.displayName
            self?.mainEvent.value = response.mainEvent
        }
    }
    
    func loadMainImageData(fileName: String) {
        sendApiRequest(url: .mainEventImage(fileName: fileName), method: .get, contentType: .image) { [weak self] data in
            self?.eventImageData.value = data
        }
    }
    private func sendApiRequest(url: EndPoint, method: HttpMethod, contentType: ContentType, successHandler: @escaping (Data) -> Void) {
        networkHandler?.request(url: url, method: method, contentType: contentType) { [weak self] result in
            switch result {
            case .success(let data):
                successHandler(data)
            case .failure(let error):
                self?.logger.error("\(error.localizedDescription)")
            }
        }
    }
    
}
