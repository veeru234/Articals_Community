//
//  OfflineView.swift
//  Articles Community
//
//  Created by Veeru Masal on 09/10/26.
//


import UIKit

final class OfflineView: UIView {

    /// Called when Retry is tapped.
    var onRetry: (() -> Void)?

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let retryButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        backgroundColor = UIColor(white: 0.85, alpha: 1)

        // Icon
        iconView.image = UIImage(named:"offLineMode")
        iconView.tintColor = UIColor(white: 0.15, alpha: 1)
        iconView.contentMode = .scaleAspectFit

        // Title
        titleLabel.text = "You’re offline"
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 20) ?? .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        // Message
        messageLabel.text = "Please connect to the internet and try again."
        messageLabel.font = UIFont(name: "Roboto-Light", size: 18) ?? .systemFont(ofSize: 18, weight: .light)
        messageLabel.textColor = UIColor(white: 0.4, alpha: 1)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        // Retry button (pill)
        var config = UIButton.Configuration.filled()
        config.title = "Retry"
        config.image = UIImage(systemName: "arrow.counterclockwise")
        config.imagePadding = 10
        config.cornerStyle = .capsule
        config.baseBackgroundColor = UIColor(white: 0.93, alpha: 1)
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 18, bottom: 10, trailing: 22)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var attrs = attrs
            attrs.font = UIFont(name: "Roboto-Bold", size: 17) ?? .systemFont(ofSize: 17, weight: .bold)
            return attrs
        }
        retryButton.configuration = config
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

        // Layout
        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel, messageLabel, retryButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.setCustomSpacing(24, after: messageLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 80),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }

    // MARK: - Actions
    @objc private func retryTapped() {
        setLoading(true)
        onRetry?()
    }

    /// Shows a spinner on the button and blocks double taps while the API call runs.
    func setLoading(_ loading: Bool) {
        retryButton.configuration?.showsActivityIndicator = loading
        retryButton.isUserInteractionEnabled = !loading
    }
}
