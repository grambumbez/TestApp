
import UIKit
import SDWebImage

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    lazy var myQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "myQueue"
        return queue
    }()
    
    func configCell(article: Article) {
        newsImage.layer.cornerRadius = 10
        titleLabel.text = article.title
        authorLabel.text = article.author
        
//        myQueue.addOperation {
//            if let urlImage = URL(string: article.urlToImage) {
//                self.newsImage.sd_setImage(with: urlImage, completed: nil)
//            }
//        }
        
        DispatchQueue.global(qos: .utility).async {
            if let urlImage = URL(string: article.urlToImage) {
                DispatchQueue.main.async {
                    self.newsImage.sd_setImage(with: urlImage, completed: nil)
                }
            }
        }
    }
}
extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

  
