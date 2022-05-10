import Foundation
import OSLog
import Alamofire

enum ContentType {
    case json
    case image
    
    var value: String {
        switch self {
        case .image:
            return "image/jpeg"
        case .json:
            return "applicatin/json"
        }
    }
}

enum EndPoint {
    case initialEventImage
    
    var urlString: String {
        switch self {
        case .initialEventImage:
            return "https://s3.ap-northeast-2.amazonaws.com/lucas-image.codesquad.kr/1627033273796event-bg.png"
        }
    }
}

enum HttpMethod {
    case get
    case post
}

enum HttpError: Error, CustomStringConvertible{
    case normalError(error: Error)
    case unknownError
    
    var description: String{
        switch self {
        case .normalError(let error):
            return error.localizedDescription
        case .unknownError:
            return "Unknown Error"
        }
    }
}

struct NetworkHandler: NetworkHandlable{
    
    private let logger: Logger
    
    init() {
        logger = Logger()
    }
    
    func request(url: EndPoint, method: HttpMethod, contentType: ContentType, completionHandler: @escaping (Result<Data,Error>)->Void){
        
        AF.request(convertToHttps(url: url),
                   method: HTTPMethod(rawValue: "\(method)"),
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":contentType.value])
        .validate(statusCode: 200..<300)
        .responseData{response in
            switch response.result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func convertToHttps(url: EndPoint) -> String {
        guard var urlComponents = URLComponents(string: url.urlString) else { return url.urlString }
    
        urlComponents.scheme = "https"
        guard let urlString = urlComponents.string else { return url.urlString }
        return urlString
    }

    
}
