
import UIKit
import RxCocoa
import RxSwift

class PhotoView: UIViewController {
    
    
    private let disposeBag = DisposeBag()
    private let loadPost = PostApp()
    let spacing:CGFloat = 5
    let photoPerRow:CGFloat = 2
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.delegate = self
        bindUi()
    }
    
    func bindUi() {
        loadPost.loadPhoto().bind(to: photoCollectionView.rx.items(cellIdentifier: "PhotoCell", cellType: PhotoCell.self)) { row, post, cell in
            cell.configCell(photo: post)
        }.disposed(by: self.disposeBag)
    }
}

extension PhotoView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = self.spacing * (self.photoPerRow + 1)
        let avaiLableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avaiLableWidth/self.photoPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.spacing, left: self.spacing, bottom: self.spacing, right: self.spacing)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.spacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.spacing
    }
}
  
