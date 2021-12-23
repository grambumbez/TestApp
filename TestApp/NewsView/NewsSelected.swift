
import UIKit
import WebKit
import RxSwift
import RxCocoa

class NewsSelected: UIViewController, WKUIDelegate {
    var webView: WKWebView?
    var article: Article?

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let articleURL = article?.url else {return}
            DispatchQueue.global(qos: .utility).async {
                if let postURL = URL(string: articleURL) {
                    DispatchQueue.main.async {
                        let web = URLRequest(url:postURL)
                        self.webView?.load(web)
                    }
                }
            }
    }
}
  
