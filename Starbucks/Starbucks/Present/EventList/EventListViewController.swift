import UIKit

final class EventListViewController: UIViewController {
    
    private var eventListViewModel: EventListViewModel?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.sectionInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(EventListCollectionViewCell.self,
                                forCellWithReuseIdentifier: EventListCollectionViewCell.identifier)
        return collectionView
    }()
    
    convenience init(eventListViewModel: EventListViewModel) {
        self.init()
        self.eventListViewModel = eventListViewModel
        addViews()
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
        self.eventListViewModel?.eventInfoList.bind { _ in
            //DTO List 가지고 UI 업데이트하는 로직 실행
        }
    }
}
