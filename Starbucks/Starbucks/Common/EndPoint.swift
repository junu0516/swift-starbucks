import Foundation

enum EndPoint {
    case initialEventImage
    case homeData
    case mainEventImage
    
    var urlString: String {
        switch self {
        case .initialEventImage:
            return "https://s3.ap-northeast-2.amazonaws.com/lucas-image.codesquad.kr/1627033273796event-bg.png"
        case .homeData:
            return "https://api.codesquad.kr/starbuckst"
        case .mainEventImage:
            return "https://image.istarbucks.co.kr/upload/promotion/APP_THUM_20210719090612417.jpg"
        }
    }
}
