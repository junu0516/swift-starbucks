import Foundation

enum EndPoint {
    case initialEventImage
    case homeData
    case mainEventImage(fileName: String, fileUrl: String)
    case productInfo
    case productImage
    case productImageData(filePath: String, fileUrl: String)
    
    var urlString: String {
        switch self {
        case .initialEventImage:
            return "https://s3.ap-northeast-2.amazonaws.com/lucas-image.codesquad.kr/1627033273796event-bg.png"
        case .homeData:
            return "https://api.codesquad.kr/starbuckst"
        case .mainEventImage(let fileName, let fileUrl):
            return "\(fileUrl)\(fileName)"
        case .productInfo:
            return "https://www.starbucks.co.kr/menu/productViewAjax.do"
        case .productImage:
            return "https://www.starbucks.co.kr/menu/productFileAjax.do"
        case .productImageData(let filePath, let fileUrl):
            return "\(fileUrl)/\(filePath)"
            
        }
    }
}
