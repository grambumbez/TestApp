
import Foundation

class Photo: Decodable {
    let urls: Urls
    
    enum CodingKeys: String, CodingKey {
        case urls = "urls"
    }
}
class Urls: Decodable {
    let small: String
    let thumb: String
    let regular: String
    
    enum CodingKeys: String, CodingKey {
        case small = "small"
        case thumb = "thumb"
        case regular = "regular"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        small = try container.decodeIfPresent(String.self, forKey: .small) ?? "Unknown small"
        thumb = try container.decodeIfPresent(String.self, forKey: .thumb) ?? "Unknown thumb"
        regular = try container.decodeIfPresent(String.self, forKey: .regular) ?? "Unknown regular"
    }
}
struct Configuration {
    static let baseUrl = "https://api.unsplash.com/photos"
    static let clientId = "Client-ID BQRPt7m843tLQf2RS5kYCsajnHm-6th7LS6cIlN7s1Y"
}

   
