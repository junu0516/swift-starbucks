import UIKit

final class RecommendationCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "RecommendationCollectionViewCell"
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
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
    }
    
    private func setLayout() {
        productImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    func updateProductImage(imageData: Data) {
        productImageView.image = UIImage(data: imageData)
    }
}
