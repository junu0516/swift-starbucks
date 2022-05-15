import Foundation
import OSLog
import Alamofire

enum ContentType {
    case json
    case image
    case urlEncoded
    
    var value: String {
        switch self {
        case .image:
            return "image/jpeg"
        case .json:
            return "applicatin/json"
        case .urlEncoded:
            return "application/x-www-form-urlencoded; charset=utf-8"
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
    private let jsonHandler: JSONHandlable
    
    init() {
        logger = Logger()
        jsonHandler = JSONHandler()
    }
    
    func request(url: EndPoint, method: HttpMethod, contentType: ContentType, body: Data?, completionHandler: @escaping (Result<Data,Error>)->Void){
        guard var request = try? URLRequest(url: convertToHttps(url: url), method: HTTPMethod(rawValue: "\(method)"), headers: ["Content-Type":contentType.value]) else { return }
        request.httpBody = contentType == .urlEncoded ? convertJSONToFormData(jsonData: body) : body
        
        AF.request(request)
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
    
    private func convertJSONToFormData(jsonData: Data?) -> Data? {
        guard let jsonData = jsonData else { return nil }
        guard let parameters = jsonHandler.convertJSONToObject(from: jsonData, to: [String:String].self) else { return nil }
        var formData: String = ""
        parameters.forEach { formData += "\($0.key)=\($0.value)&" }
        return formData.dropLast().data(using: .utf8, allowLossyConversion: true)
    }
    
}
