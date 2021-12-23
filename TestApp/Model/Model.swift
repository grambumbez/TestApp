
import Foundation
import Alamofire
import RxSwift
import RxCocoa

class PostApp {

    private let urlStringNews = "https://newsapi.org/v2/top-headlines?country=ru&apiKey=fb85741bd56f49a59a1bea3d174959ff"
    private let urlIp = URL(string: "https://api.ipify.org")
     
    
    final func loadNews() -> Observable<[Article]> {
        return Observable.create({ (observer) in
            AF.request(self.urlStringNews).response { response in
                if let data = response.data {
                    do {
                        let newsResponse = try JSONDecoder().decode(NewsApi.self, from: data)
                        observer.on(.next(newsResponse.articles))
                    }
                    catch let error {
                        print(error)
                    }
                }
            }
            return Disposables.create()
        })
    }
    
    final func ipQuery() -> Observable<checkIp>  {
        return Observable.create({ (observer) in
            let ipAddress = try? String(contentsOf: self.urlIp!)
            let countryUrl = "http://ipwhois.app/json/\(ipAddress ?? "")?lang=ru/objects=country,city,timezone,latitude,longitude"
            print("My IP address: " + ipAddress!)
            AF.request(countryUrl).response { response in
                if let data = response.data {
                    do {
                        let ipResponse = try JSONDecoder().decode(checkIp.self, from: data)
                        observer.on(.next(ipResponse))
                        print(ipResponse.latitude)
                        print(ipResponse.longitude)
                    }
                    catch let error {
                        print(error)
                    }
                }
            }
            return Disposables.create()
        })
    }
    
    final func loadPhoto() -> Observable<[Photo]> {
        var urlComponents = URLComponents(string: Configuration.baseUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(1)"),
            URLQueryItem(name: "per_page", value: "30")
        ]
        let url = urlComponents?.url
        let request = NSMutableURLRequest(url: url!)
            request.addValue(Configuration.clientId, forHTTPHeaderField: "Authorization")

        return Observable.create({ (observer) in
            AF.request(request as URLRequest).response { response in
                if let data = response.data {
                    do {
                        let photoLoad = try JSONDecoder().decode([Photo].self, from: data)
                        observer.on(.next(photoLoad))
                    }
                    catch let error {
                        print(error)
                    }
                }
            }
            return Disposables.create()
        })
    }
}

  
