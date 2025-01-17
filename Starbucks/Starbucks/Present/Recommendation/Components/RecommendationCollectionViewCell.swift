import UIKit

final class RecommendationCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "RecommendationCollectionViewCell"
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 70
        return imageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .center
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
        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
    }
    
    private func setLayout() {
        productImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 5).isActive = true
        productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        productNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func updateProductImage(imageData: Data) {
        productImageView.image = UIImage(data: imageData)
    }
    
    func updateProductName(productName: String) {
        productNameLabel.text = productName
    }
}
