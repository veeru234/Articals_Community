//
//  ArticalsGridViewCollectionViewCell.swift
//  Articles Community
//
//  Created by Veeru Masal on 09/10/26.
//

import UIKit
import Kingfisher

final class ArticalsGridViewCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var articalImage: UIImageView!
    @IBOutlet weak var articalDescription: UILabel!

    // MARK: - Layout constants (shared with the view controller for item sizing)
    static let padding: CGFloat = 10            // inside the card
    static let imageAspect: CGFloat = 0.56      // must match the XIB multiplier
    static let titleLines: Int = 2
    static let titleFont: UIFont = UIFont(name: "Roboto-Medium", size: 15)
        ?? .systemFont(ofSize: 15, weight: .medium)

    /// Total cell height for a given cell width.
    static func height(forWidth width: CGFloat) -> CGFloat {
        let imageWidth = width - padding * 2
        let imageHeight = imageWidth * imageAspect
        let titleHeight = ceil(titleFont.lineHeight) * CGFloat(titleLines)
        return padding + imageHeight + 10 + titleHeight + 12
    }

    // MARK: - Loader
    private let loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        articalDescription.font = Self.titleFont
        articalDescription.numberOfLines = Self.titleLines
        articalDescription.lineBreakMode = .byTruncatingTail

        articalImage.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: articalImage.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: articalImage.centerYAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        articalImage.kf.cancelDownloadTask()
        articalImage.image = nil
        articalDescription.text = nil
        loader.stopAnimating()
    }

    // MARK: - Configure
    func configure(title: String, imageURLString: String?) {
        articalDescription.text = title

        guard let urlString = imageURLString,
              let url = URL(string: urlString) else {
            loader.stopAnimating()
            articalImage.image =  UIImage(named: "ListPlaceholder")
            articalImage.tintColor = UIColor.white.withAlphaComponent(0.4)
            return
        }

        loader.startAnimating()

        articalImage.kf.setImage(
            with: url,
            options: [
                .transition(.fade(0.25)),
                .cacheOriginalImage
            ]
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.loader.stopAnimating()
            case .failure(let error):
                if error.isTaskCancelled || error.isNotCurrentTask { return }
                self.loader.stopAnimating()
                self.articalImage.image = UIImage(named: "ListPlaceholder")
                self.articalImage.tintColor = UIColor.white.withAlphaComponent(0.4)
            }
        }
    }
}
