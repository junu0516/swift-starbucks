import UIKit

final class HomeViewController: UIViewController {
    
    private var homeViewModel: HomeViewModel?
    
    private let recommendationViewControllers: [RecommendationCategory: RecommendationViewController] = {
        var viewControllers: [RecommendationCategory:RecommendationViewController] = [:]
        RecommendationCategory.allCases.forEach {
            let viewModel = RecommendationViewModel(networkHandler: NetworkHandler(), jsonHandler: JSONHandler())
            let viewController = RecommendationViewController(recommendationViewModel: viewModel, category: $0)
            viewControllers[$0] = viewController
        }
        return viewControllers
    }()
    
    private let eventListViewController: EventListViewController = {
        let viewModel = EventListViewModel(networkHandler: NetworkHandler(), jsonHandler: JSONHandler())
        let viewController = EventListViewController(eventListViewModel: viewModel)
        return viewController
    }()
    
    private lazy var homeHeaderView: HomeHeaderView = {
        let headerView = HomeHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    private var homeHeaderViewTopConstraint: NSLayoutConstraint?
    
    private lazy var homeScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var mainEventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    private lazy var personalRecommendatilTitleView: PersonalRecommendationTitleView = {
        let recommendationView = PersonalRecommendationTitleView()
        recommendationView.translatesAutoresizingMaskIntoConstraints = false
        return recommendationView
    }()
    
    private lazy var eventListTitleView: EventListTitleView = {
        let eventListTitleView = EventListTitleView()
        eventListTitleView.translatesAutoresizingMaskIntoConstraints = false
        return eventListTitleView
    }()
    
    private lazy var timeRecommendationTitleView: TimeRecommendationTitleView = {
        let timeRecommendationTitleView = TimeRecommendationTitleView()
        timeRecommendationTitleView.translatesAutoresizingMaskIntoConstraints = false
        return timeRecommendationTitleView
    }()
    
    convenience init(homeViewModel: HomeViewModel) {
        self.init()
        self.homeViewModel = homeViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeScrollView.delegate = self
        addViews()
        setLayout()
        bind()
    }
    
    private func bind() {
        homeViewModel?.eventImageData.bind{ [weak self] data in
            self?.mainEventImageView.image = UIImage(data: data)
        }
        
        homeViewModel?.displayName.bind{ [weak self] displayName in
            self?.personalRecommendatilTitleView.titleLabel.text = displayName
        }
        
        homeViewModel?.mainEvent.bind{ [weak self] mainEvent in
            if mainEvent.imageUrl.count <= 0 { return }
            self?.homeViewModel?.loadMainImageData(fileName: mainEvent.imageFileName, fileUrl: mainEvent.imageUrl)
        }
        
        homeViewModel?.personalRecommendations.bind{ [weak self] recommendation in
            if recommendation.products.count <= 0 { return }
            guard let recommendationViewModel = self?.recommendationViewControllers[.personal]?.recommendationViewModel else { return }
            DispatchQueue.global(qos: .userInteractive).async {
                guard let list = self?.homeViewModel?.loadRecommendationData(productIds: recommendation.products) else { return }
                recommendationViewModel.recommendations.value = list
            }
        }
        
        homeViewModel?.timeRecommendations.bind{ [weak self] recommendation in
            if recommendation.products.count <= 0 { return }
            guard let recommendationViewModel = self?.recommendationViewControllers[.time]?.recommendationViewModel else { return }
            DispatchQueue.global(qos: .userInteractive).async {
                guard let list = self?.homeViewModel?.loadRecommendationData(productIds: recommendation.products) else { return }
                recommendationViewModel.recommendations.value = list
            }
        }
    }
    
    private func addViews() {
        guard let personalRecommendationView = recommendationViewControllers[.personal]?.view,
              let timeRecommendationView = recommendationViewControllers[.time]?.view else { return }
        
        view.addSubview(homeHeaderView)
        view.addSubview(homeScrollView)
        
        homeScrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(mainEventImageView)
        contentStackView.addArrangedSubview(personalRecommendatilTitleView)
        contentStackView.addArrangedSubview(personalRecommendationView)
        contentStackView.addArrangedSubview(eventListTitleView)
        contentStackView.addArrangedSubview(eventListViewController.view)
        contentStackView.addArrangedSubview(timeRecommendationTitleView)
        contentStackView.addArrangedSubview(timeRecommendationView)
    }
    
    private func setLayout() {
        homeHeaderViewTopConstraint = homeHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        
        homeHeaderViewTopConstraint?.isActive = true
        homeHeaderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        homeHeaderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        homeHeaderView.heightAnchor.constraint(equalToConstant: 230).isActive = true
        
        homeScrollView.topAnchor.constraint(equalTo: homeHeaderView.bottomAnchor, constant: 10).isActive = true
        homeScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        homeScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        homeScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contentStackView.topAnchor.constraint(equalTo: homeScrollView.topAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: homeScrollView.bottomAnchor, constant: -50).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: homeScrollView.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: homeScrollView.trailingAnchor).isActive = true
        contentStackView.widthAnchor.constraint(equalTo: homeScrollView.widthAnchor).isActive = true
        
        mainEventImageView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
        mainEventImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        personalRecommendatilTitleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        personalRecommendatilTitleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        personalRecommendatilTitleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        recommendationViewControllers[.personal]?.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        recommendationViewControllers[.personal]?.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        recommendationViewControllers[.personal]?.view.heightAnchor.constraint(equalToConstant: 180).isActive = true

        eventListTitleView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
        eventListTitleView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        eventListViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        eventListViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        eventListViewController.view.heightAnchor.constraint(equalToConstant: 220).isActive = true

        timeRecommendationTitleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        timeRecommendationTitleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        timeRecommendationTitleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        recommendationViewControllers[.time]?.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        recommendationViewControllers[.time]?.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        recommendationViewControllers[.time]?.view.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let isScrollingDown = offsetY < 0
        let limit = homeHeaderView.welcomeImageView.frame.height + 60
        let collapsableHeight = offsetY > limit ? limit : offsetY
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, options: [], animations: { [weak self] in
            self?.homeHeaderView.welcomeImageView.alpha = isScrollingDown ? 1.0 : 3/offsetY
            self?.homeHeaderViewTopConstraint?.constant = -collapsableHeight
            self?.view.layoutIfNeeded()
        })
    }
}
