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
        //addViews()
        //setLayout()
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
        recommendationViewModel?.recommendations.bind { recommendation in
            if recommendation.count <= 0 { return }
            //동기적으로 이미지 데이터 요청해서 뷰모델의 이미지 데이터 배열 업데이트
        }
    }
}

extension RecommendationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let recommendation = recommendationViewModel?.recommendations.value as? [Data] else { return 0 }
        return recommendation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
    }
}
