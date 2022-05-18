import UIKit

final class EventListCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "EventListCollectionViewCell"
    
    private lazy var eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var eventTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = ""
        return label
    }()
    
    private lazy var eventSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.text = ""
        return label
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
        contentView.addSubview(eventImageView)
        contentView.addSubview(eventTitleLabel)
        contentView.addSubview(eventSubTitleLabel)
    }
    
    private func setLayout() {
        eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        eventImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        eventImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75).isActive = true
        
        eventTitleLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor).isActive = true
        eventTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        eventTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        eventTitleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.125).isActive = true
        
        eventSubTitleLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor).isActive = true
        eventSubTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        eventSubTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        eventSubTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func updateEventImage(eventImage: Data) {
        eventImageView.image = UIImage(data: eventImage)
    }
    
    func updateEventTitle(eventTitle: String) {
        eventTitleLabel.text = eventTitle
    }
    
    func updateEventSubTitle(eventSubTitle: String) {
        eventSubTitleLabel.text = eventSubTitle
    }

}
