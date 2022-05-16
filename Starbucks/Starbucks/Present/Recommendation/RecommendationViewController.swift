import UIKit

final class RecommendationViewController: UIViewController {
    
    private var category: RecommendationCategory?
    private (set) var recommendationViewModel: RecommendationViewModel?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130, height: 150)
        layout.sectionInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RecommendationCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendationCollectionViewCell.identifier)
        return collectionView
    }()
    
    convenience init(recommendationViewModel: RecommendationViewModel, category: RecommendationCategory) {
        self.init()
        self.recommendationViewModel = recommendationViewModel
        self.category = category
        collectionView.delegate = self
        collectionView.dataSource = self
        addViews()
        setLayout()
        bind()
    }
    
    private func addViews() {
        view.addSubview(collectionView)
    }
    
    private func setLayout() {
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func bind() {
        recommendationViewModel?.recommendations.bind { [weak self] recommendation in
            if recommendation.count <= 0 { return }
            self?.recommendationViewModel?.loadProductData()
        }
        
        recommendationViewModel?.productList.bind { [weak self] imageList in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

extension RecommendationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let productList = recommendationViewModel?.productList.value as? [Product] else { return 0 }
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCollectionViewCell.identifier, for: indexPath) as? RecommendationCollectionViewCell,
              let product = recommendationViewModel?.productList.value[indexPath.row] else { return UICollectionViewCell() }
 
        cell.updateProductImage(imageData: product.productImage)
        cell.updateProductName(productName: product.productName)
        return cell
    }
}
