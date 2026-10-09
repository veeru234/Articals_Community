//
//  ArticalsListTableViewCell.swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//

import UIKit
import Kingfisher

class ArticalsListTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    
    var onReadMoreTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        articleImage.contentMode = .scaleAspectFill
        articleImage.clipsToBounds = true
        readMoreButton.addTarget(self, action: #selector(readMoreTapped), for: .touchUpInside)
    }
    
    
    
    @objc private func readMoreTapped() {
        debugPrint("Read more is called")
        onReadMoreTapped?()
    }

    func configureCell(article: Article) {

        // MARK: - Image
        self.articleImage.clipsToBounds = true
        if let imageURL = article.urlToImage,
           let url = URL(string: imageURL) {

            articleImage.kf.setImage(
                with: url,
                placeholder: UIImage(named: "ListPlaceholder"),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )

        } else {
            articleImage.image = UIImage(named: "ListPlaceholder")
        }

        // MARK: - Description
        articleDescriptionLabel.text = article.title ?? article.description ?? ""

        // MARK: - Date
        articleDateLabel.text = formatDate(article.publishedAt)

        // MARK: - Button
        readMoreButton.setTitle("Read More", for: .normal)
    }

    private func formatDate(_ dateString: String?) -> String {

        guard let dateString = dateString else {
            return ""
        }

        let formatter = ISO8601DateFormatter()

        guard let date = formatter.date(from: dateString) else {
            return dateString
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")

        return outputFormatter.string(from: date)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        articleImage.kf.cancelDownloadTask()

        articleImage.image = UIImage(named: "ListPlaceholder")
        articleDescriptionLabel.text = nil
        articleDateLabel.text = nil
    }
}
