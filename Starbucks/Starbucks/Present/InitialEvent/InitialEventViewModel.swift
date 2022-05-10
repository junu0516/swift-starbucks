import Foundation

final class InitialEventViewModel {
    
    let eventImage = Observable<Data>(Data())
    private var networkHandler: NetworkHandlable
    
    init(networkHandler: NetworkHandlable) {
        self.networkHandler = networkHandler
        loadEventImage()
    }
    
    private func loadEventImage() {
        networkHandler.request(url: .initialEventImage, method: .get, contentType: .image){ [weak self] result in
            switch result {
            case .success(let data):
                self?.eventImage.value = data
            case .failure(let error):
                //에러 처리
                print(error)
            }
        }
    }
}
