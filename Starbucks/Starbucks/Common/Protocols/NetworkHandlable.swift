import Foundation

protocol NetworkHandlable{
    func request(url: EndPoint, method: HttpMethod, contentType: ContentType, completionHandler: @escaping (Result<Data,Error>)->Void)
}
