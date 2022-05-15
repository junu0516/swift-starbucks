import Foundation

protocol NetworkHandlable{
    func request(url: EndPoint, method: HttpMethod, contentType: ContentType, body: Data?, completionHandler: @escaping (Result<Data,Error>)->Void)
}
