import Foundation
import OSLog

final class RecommendationViewModel {
    
    private (set) var recommendations = Observable<[Data]>([])
    private (set) var productImageList = Observable<[Data]>([])
    
    private let logger = Logger()
    private let jsonHandler: JSONHandlable = JSONHandler()
    private var networkHandler: NetworkHandlable?
    private var semaphore = DispatchSemaphore(value: 0)


    init(networkHandler: NetworkHandlable) {
        self.networkHandler = networkHandler
    }
    
    func loadProductImageData() {
        var imageDataList: [Data] = []
        let requestDataList = recommendations.value
        requestDataList.forEach { [weak self] in
            guard let requestDataList = self?.jsonHandler.convertJSONToObject(from: $0, to: ImageFileRequestList.self) else { return }
            if requestDataList.file.count <= 0 { return }
            let requestData = requestDataList.file[0]
            let url = EndPoint.productImageData(filePath: requestData.filePath, fileUrl: requestData.fileUrl)
            self?.sendApiRequest(url: url, method: .get, contentType: .image, body: nil) { data in
                imageDataList.append(data)
                self?.semaphore.signal()
            }
            semaphore.wait()
        }
        productImageList.value = imageDataList
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
