import UIKit

final class RecommendationViewController: UIViewController {
    
    private var category: RecommendationCategory?
    private (set) var recommendationViewModel: RecommendationViewModel?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    convenience init(recommendationViewModel: RecommendationViewModel, category: RecommendationCategory) {
        self.init()
        self.recommendationViewModel = recommendationViewModel
        self.category = category
    }
    
}
