//
//  ArticalDetailsViewController.swift
//  Articles Community
//
//  Created by Veeru Masal on 09/10/26.
//

import UIKit
import Kingfisher

class ArticalDetailsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var labelArticalName: UILabel!
    @IBOutlet weak var labelArticalDescription: UILabel!
    @IBOutlet weak var labelpublishedTime: UILabel!
    @IBOutlet weak var ArticleImage: UIImageView!

    var articleDetail: Article?

    override func viewDidLoad() {
        super.viewDidLoad()
        labelArticalName.numberOfLines = 0
        labelArticalDescription.numberOfLines = 0
        populate()
    }

    private func populate() {
        guard let article = articleDetail else { return }

        labelArticalName.text = article.title
        labelArticalDescription.text = article.description ?? article.content
        labelpublishedTime.text = relativeTime(from: article.publishedAt)

        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            ArticleImage.kf.indicatorType = .activity
            ArticleImage.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo"),
                options: [.transition(.fade(0.25))]
            )
        } else {
            ArticleImage.image = UIImage(systemName: "photo")
        }
    }

    /// Turns an ISO‑8601 string like "2026-10-09T04:30:00Z" into "10h ago".
    private func relativeTime(from isoString: String?) -> String {
        guard let isoString,
              let date = ISO8601DateFormatter().date(from: isoString) else { return "" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    @IBAction func btnBackPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
