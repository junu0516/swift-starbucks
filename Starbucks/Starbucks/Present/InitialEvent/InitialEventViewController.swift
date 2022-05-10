import UIKit

final class InitialEventViewController: UIViewController {
    
    private var initialEventViewModel: InitialEventViewModel?
    
    private lazy var eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var buttonBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var invalidationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 0.7
        button.layer.borderColor = UIColor(named: "green_closeButton")?.cgColor
        button.layer.cornerRadius = 15
        button.setTitle("다시 보지 않기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            UserDefaults.standard.set(true, forKey: "eventInvalidated")
            self?.moveToMainTabbarView()
        }), for: .touchDown)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(named: "green_closeButton")
        button.layer.cornerRadius = 15
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.moveToMainTabbarView()
        }), for: .touchDown)
        return button
    }()
    
    convenience init(initialEventViewModel: InitialEventViewModel) {
        self.init()
        self.initialEventViewModel = initialEventViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(eventImageView)
        view.addSubview(buttonBackgroundView)
        buttonBackgroundView.addSubview(invalidationButton)
        buttonBackgroundView.addSubview(closeButton)
                
        view.backgroundColor = .white
        setLayout()
        bind()
    }
    
    private func bind() {
        initialEventViewModel?.eventImage.bind{ [weak self] data in
            self?.eventImageView.image = UIImage(data: data)
        }
    }
    
    private func setLayout() {
        eventImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        eventImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        eventImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        eventImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.85).isActive = true
        
        buttonBackgroundView.topAnchor.constraint(equalTo: eventImageView.bottomAnchor).isActive = true
        buttonBackgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        buttonBackgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        buttonBackgroundView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.15).isActive = true
        
        invalidationButton.widthAnchor.constraint(equalTo: buttonBackgroundView.widthAnchor, multiplier: 0.4).isActive = true
        invalidationButton.leadingAnchor.constraint(equalTo: buttonBackgroundView.leadingAnchor, constant: 30).isActive = true
        invalidationButton.centerYAnchor.constraint(equalTo: buttonBackgroundView.centerYAnchor).isActive = true
        
        closeButton.widthAnchor.constraint(equalTo: invalidationButton.widthAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: buttonBackgroundView.trailingAnchor, constant: -30).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: buttonBackgroundView.centerYAnchor).isActive = true
    }
    
    private func moveToMainTabbarView() {
        let tabbarView = MainTabBarController()
        tabbarView.modalPresentationStyle = .fullScreen
        self.present(tabbarView, animated: false)
    }
}
