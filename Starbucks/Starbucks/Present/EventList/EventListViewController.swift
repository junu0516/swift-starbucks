import UIKit

final class EventListViewController: UIViewController {
    
    private var eventListViewModel: EventListViewModel?
    
    private lazy var eventListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 180)
        layout.sectionInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: 30)
        
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
        setLayout()
        bind()
        eventListCollectionView.dataSource = self
        eventListCollectionView.delegate = self
    }
    
    private func addViews() {
        view.addSubview(eventListCollectionView)
    }
    
    private func setLayout() {
        eventListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        eventListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        eventListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        eventListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func bind() {
        self.eventListViewModel?.eventInfoList.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.eventListCollectionView.reloadData()
            }
        }
    }
}

extension EventListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let eventList = eventListViewModel?.eventInfoList.value as? [EventInfo] else { return 0 }
        return eventList.count
    } 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventListCollectionViewCell.identifier, for: indexPath) as? EventListCollectionViewCell else { return UICollectionViewCell() }
        guard let eventInfo = eventListViewModel?.eventInfoList.value[indexPath.row] else { return UICollectionViewCell() }
        cell.updateEventImage(eventImage: eventInfo.eventImage)
        cell.updateEventTitle(eventTitle: eventInfo.eventTitle)
        cell.updateEventSubTitle(eventSubTitle: eventInfo.eventSubTitle)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 180)
    }
    
}
