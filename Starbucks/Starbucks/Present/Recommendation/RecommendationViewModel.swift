import Foundation
import OSLog

final class RecommendationViewModel {
    
    private (set) var recommendations = Observable<[String:ProductEntity]>([:])
    private (set) var productList = Observable<[Product]>([])
    
    private let logger = Logger()
    private let jsonHandler: JSONHandlable
    private let networkHandler: NetworkHandlable?
    private var semaphore = DispatchSemaphore(value: 0)


    init(networkHandler: NetworkHandlable, jsonHandler: JSONHandlable) {
        self.networkHandler = networkHandler
        self.jsonHandler = jsonHandler
    }
    
    func loadProductData() {
        let dispatchGroup = DispatchGroup()
        var productList: [Product] = []
        let requestDataList = recommendations.value
        for (productId, productGenerator) in requestDataList {
            dispatchGroup.enter()
            
            guard let requestDataList = jsonHandler.convertJSONToObject(from: productGenerator.productImageRequestData, to: ImageFileRequestList.self) else { return }
            if requestDataList.file.count <= 0 { return }
            let requestData = requestDataList.file[0]
            let url = EndPoint.productImageData(filePath: requestData.filePath, fileUrl: requestData.fileUrl)
            
            sendApiRequest(url: url, method: .get, contentType: .image, body: nil) { data in
                let product = Product(productId: productId, productImage: data, productName: productGenerator.productInfo.productName)
                productList.append(product)
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.productList.value = productList
        }
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
