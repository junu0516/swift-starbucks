import Foundation
import OSLog

final class EventListViewModel {
    
    private (set) var eventInfoList = Observable<[EventInfo]>([])
    
    private let networkHandler: NetworkHandlable
    private let jsonHandler: JSONHandlable = JSONHandler()
    private let logger = Logger()
    
    init(networkHandler: NetworkHandlable) {
        self.networkHandler = networkHandler
        loadEventInfoListData()
    }
    
    private func loadEventInfoListData() {
        guard let requestBody = jsonHandler.convertObjectToJSON(from: EventInfoRequestEntity()) else { return }
        sendApiRequest(url: .eventList, method: .post, contentType: .urlEncoded, body: requestBody) { [weak self] data in
            guard let eventInfoEntities = self?.jsonHandler.convertJSONToObject(from: data, to: EventInfoResponseEntityList.self) else { return }
            self?.loadEventInfoList(eventInfoResponseEntities: eventInfoEntities.list)
        }
    }
        
    private func loadEventInfoList(eventInfoResponseEntities: [EventInfoResponseEntity]) {
        let dispatchGroup = DispatchGroup()
        var eventInfoList: [EventInfo] = []
        
        for eventInfoResponse in eventInfoResponseEntities {
            dispatchGroup.enter()
            
            let imageRequestEntity = eventInfoResponse.imageFileRequestEntity
            let url = EndPoint.eventImage(fileName: "/upload/promotion/\(imageRequestEntity.imageFileName)",
                                          fileUrl: imageRequestEntity.imageUrl)
            sendApiRequest(url: url, method: .get, contentType: .image, body: nil) { data in
                let eventImageData = data
                let eventInfo = EventInfo(eventTitle: eventInfoResponse.eventTitle,
                                          eventSubTitle: eventInfoResponse.eventSubTitle,
                                          eventImage: eventImageData)
                eventInfoList.append(eventInfo)
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.eventInfoList.value = eventInfoList
        }
    }
    
    private func sendApiRequest(url: EndPoint, method: HttpMethod, contentType: ContentType, body: Data?, successHandler: @escaping (Data) -> Void) {
        networkHandler.request(url: url, method: method, contentType: contentType, body: body) { [weak self] result in
            switch result {
            case .success(let data):
                successHandler(data)
            case .failure(let error):
                self?.logger.error("\(error.localizedDescription)")
            }
        }
    }
}
