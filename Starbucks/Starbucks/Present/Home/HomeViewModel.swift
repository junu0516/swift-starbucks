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
    
    func loadRecommendationData(productIds: [String]) -> [String:ProductGenerator] {
        var productDataMap: [String:ProductGenerator] = [:]
        for productId in productIds {
            
            guard let requestBody = jsonHandler.convertObjectToJSON(from: ProductImageRequest(productCd: productId)) else { continue }
            var productImageRequestData: Data = Data()
            self.sendApiRequest(url: .productImage, method: .post, contentType: .urlEncoded, body: requestBody) { [weak self] data in
                productImageRequestData = data
                self?.semaphore.signal()
            }
            semaphore.wait()

            guard let requestBody = jsonHandler.convertObjectToJSON(from: ProductInfoRequest(productCd: productId)) else { continue }
            self.sendApiRequest(url: .productInfo, method: .post, contentType: .urlEncoded, body: requestBody) { [weak self] data in
                guard let productInfoResponse = self?.jsonHandler.convertJSONToObject(from: data, to: ProductInfoResponse.self) else {
                    self?.semaphore.signal()
                    return
                }
                let productGenerator = ProductGenerator(productImageRequestData: productImageRequestData, productInfo: productInfoResponse)
                productDataMap[productId] = productGenerator
                self?.semaphore.signal()
            }
            semaphore.wait()
        }

        return productDataMap
    }
    
    private func sendApiRequest(url: EndPoint, method: HttpMethod, contentType: ContentType, body: Data?, successHandler: @escaping (Data) -> Void) {
        networkHandler?.request(url: url, method: method, contentType: contentType, body: body) { [weak self] result in
            switch result {
            case .success(let data):
                successHandler(data)
            case .failure(let error):
                self?.semaphore.signal()
                self?.logger.error("\(error.localizedDescription)")
            }
        }
    }
    
}
