
import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var photoImage: UIImageView!
    
    
    func configCell(photo: Photo) {
        DispatchQueue.global(qos: .utility).async {
            if let urlImage = URL(string: photo.urls.regular) {
                DispatchQueue.main.async {
                    self.photoImage.sd_setImage(with: urlImage, completed: nil)
                }
            }
        }
    }
}
  
