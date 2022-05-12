import UIKit

final class HomeViewController: UIViewController {
    
    private var homeViewModel: HomeViewModel?
    
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
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
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
    
    private lazy var dummyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    }
    
    private func addViews() {
        view.addSubview(homeHeaderView)
        view.addSubview(homeScrollView)
        homeScrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(mainEventImageView)
        contentStackView.addArrangedSubview(personalRecommendatilTitleView)
        contentStackView.addArrangedSubview(dummyView)
    }
    
    private func setLayout() {
        homeHeaderViewTopConstraint = homeHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        
        homeHeaderViewTopConstraint?.isActive = true
        homeHeaderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        homeHeaderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        homeScrollView.topAnchor.constraint(equalTo: homeHeaderView.bottomAnchor).isActive = true
        homeScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        homeScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        homeScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contentStackView.topAnchor.constraint(equalTo: homeScrollView.topAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: homeScrollView.bottomAnchor).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: homeScrollView.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: homeScrollView.trailingAnchor).isActive = true
        contentStackView.widthAnchor.constraint(equalTo: homeScrollView.widthAnchor).isActive = true
        
        mainEventImageView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
        mainEventImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        personalRecommendatilTitleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        personalRecommendatilTitleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        personalRecommendatilTitleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        dummyView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
        dummyView.heightAnchor.constraint(equalToConstant: 1500).isActive = true
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let isSwiped = offsetY <= 0
        let willCollapse = offsetY > 30
        let collapsableHeight = homeHeaderView.welcomeLabel.frame.height + 40
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, options: [], animations: { [weak self] in
            self?.homeHeaderView.welcomeLabel.alpha = isSwiped ? 1.0 : 0.0
            self?.homeHeaderViewTopConstraint?.constant = willCollapse ? -collapsableHeight : 0
            self?.view.layoutIfNeeded()
        })
    }
}
