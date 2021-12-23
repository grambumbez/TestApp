
import UIKit
import RxCocoa
import RxSwift
import Alamofire
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), type: .ballPulseSync, color: .red, padding: 20)
//        activityIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
//        self.view.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
        
        
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        btn.center = CGPoint(x: view.center.x, y: view.center.y + 80)
        btn.backgroundColor = .orange
        btn.setTitle("Sign In", for: .normal)
        btn.layer.cornerRadius = 10
        self.view.addSubview(btn)
        
        btn.rx.tap.subscribe(onNext: {
            guard let postVC = self.storyboard?.instantiateViewController(identifier: "BarViewController") else {return}
            self.navigationController?.pushViewController(postVC, animated: true)
        }).disposed(by: disposeBag)
    }
}

extension UITextField {
    func indent(size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}
 
