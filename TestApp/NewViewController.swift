
import UIKit
import WebKit

class NewViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView?
    let myURL = URL(string: "https://yandex.ru")
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let web = URLRequest(url:myURL!)
        self.webView?.load(web)
    }
}
 
