
import Foundation


struct checkIp: Decodable {
    var country: String
    var city: String
    var timezone: String
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case country = "country"
        case city = "city"
        case timezone = "timezone"
        case latitude = "latitude"
        case longitude = "longitude"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        country = try container.decodeIfPresent(String.self, forKey: .country) ?? "Unknown country"
        city = try container.decodeIfPresent(String.self, forKey: .city) ?? "No city"
        timezone = try container.decodeIfPresent(String.self, forKey: .timezone) ?? "No timezone"
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 39.0437567
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? -77.4874416
    }
}

struct NewsApi: Decodable {
    var status: String
    var articles: [Article]
}

struct Article: Decodable {
    //var sourceName: String
    var author: String
    var title: String
    var description: String
    var url: String
    var urlToImage: String
    var publishedAt: String
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case author = "author"
        case title = "title"
        case description = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case content = "content"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = try container.decodeIfPresent(String.self, forKey: .author) ?? ""
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage) ?? ""
        publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt) ?? ""
        content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
    }
}
  
 

