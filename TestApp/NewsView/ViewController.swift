
import UIKit
import RxCocoa
import RxSwift


class ViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let loadPost = PostApp()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    func bindUI() {
        loadPost.loadNews().bind(to: self.myTableView.rx.items(cellIdentifier: "TableViewCell", cellType: TableViewCell.self)) { row, post, cell in
            cell.configCell(article: post)
        }.disposed(by: self.disposeBag)
        
        myTableView.rx.modelSelected(Article.self).subscribe(onNext: {
            obs in
            let vc = self.storyboard?.instantiateViewController(identifier: "NewsSelected") as! NewsSelected
            vc.article = obs
            self.navigationController?.pushViewController(vc, animated: true)
            if let selectedRowIndexPath = self.myTableView.indexPathForSelectedRow {
                self.myTableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
        }).disposed(by: disposeBag)
    }
}
  
