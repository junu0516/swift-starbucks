import Foundation
import OSLog

final class HomeViewModel {
    
    private (set) var mainEvent = Observable<MainEvent>(MainEvent())
    private (set) var eventImageData = Observable<Data>(Data())
    private (set) var displayName = Observable<String>("USER NAME")
    private (set) var personalRecommendations = Observable<Recommendation>(Recommendation())
    private (set) var timeRecommendations = Observable<Recommendation>(Recommendation())

    private var networkHandler: NetworkHandlable?
    private var jsonHandler: JSONHandlable = JSONHandler()
    private var semaphore = DispatchSemaphore(value: 0)
    private let logger = Logger()
    
    init(networkHandler: NetworkHandlable) {
        self.networkHandler = networkHandler
        loadUserData()
    }
    
    func loadUserData() {
        sendApiRequest(url: .homeData, method: .get, contentType: .json, body: nil) { [weak self] data in
            guard let response = self?.jsonHandler.convertJSONToObject(from: data, to: HomeDataResponse.self) else { return }
            self?.displayName.value = response.displayName
            self?.mainEvent.value = response.mainEvent
            self?.personalRecommendations.value = response.personalRecommendations
        }
    }
    
    func loadMainImageData(fileName: String, fileUrl: String) {
        sendApiRequest(url: .mainEventImage(fileName: fileName, fileUrl: fileUrl), method: .get, contentType: .image, body: nil) { [weak self] data in
            self?.eventImageData.value = data
        }
    }
    
    func loadRecommendationData(productIds: [String]) -> [Data] {
        var list: [Data] = []
        print(productIds)
        productIds.forEach { [weak self] in
            guard let requestBody = jsonHandler.convertObjectToJSON(from: ProductImageRequest(productCd: $0)) else { return }
            self?.sendApiRequest(url: .productImage, method: .post, contentType: .urlEncoded, body: requestBody) { data in
                list.append(data)
                self?.semaphore.signal()
            }
            semaphore.wait()
        }
        return list
    }
    
    private func sendApiRequest(url: EndPoint, method: HttpMethod, contentType: ContentType, body: Data?, successHandler: @escaping (Data) -> Void) {
        networkHandler?.request(url: url, method: method, contentType: contentType, body: body) { [weak self] result in
            switch result {
            case .success(let data):
                successHandler(data)
            case .failure(let error):
                self?.logger.error("\(error.localizedDescription)")
            }
        }
    }
    
}
