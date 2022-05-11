import UIKit

final class HomeHeaderView: UIView {
    
    private (set) var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.text = "Welcome to\nStarbucks! ☕️"
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var inboxButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("✉️ What's New", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(welcomeLabel)
        addSubview(inboxButton)
    }
    
    private func setLayout() {
        welcomeLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        welcomeLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        welcomeLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        inboxButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10).isActive = true
        inboxButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        bottomAnchor.constraint(equalTo: inboxButton.bottomAnchor).isActive = true
    }
}
