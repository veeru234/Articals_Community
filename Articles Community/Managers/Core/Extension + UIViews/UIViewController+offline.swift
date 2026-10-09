//
//  UIViewController+offline.swift
//  Articles Community
//
//  Created by Veeru Masal on 09/10/26.
//

import Foundation
import UIKit

extension UIViewController {

    private var offlineTag: Int { 987_654 }
    func showOfflineView(below anchor: UIView? = nil,
                         onRetry: @escaping (_ done: @escaping () -> Void) -> Void) {

        // Already showing: just stop the spinner and refresh the retry action.
        if let existing = view.viewWithTag(offlineTag) as? OfflineView {
            existing.onRetry = { [weak existing] in
                onRetry { existing?.setLoading(false) }
            }
            existing.setLoading(false)
            return
        }

        let offline = OfflineView()
        offline.tag = offlineTag
        offline.translatesAutoresizingMaskIntoConstraints = false
        offline.onRetry = { [weak offline] in
            onRetry { offline?.setLoading(false) }
        }

        view.addSubview(offline)
        NSLayoutConstraint.activate([
            offline.topAnchor.constraint(equalTo: anchor?.bottomAnchor ?? view.topAnchor),
            offline.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            offline.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            offline.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func hideOfflineView() {
        view.viewWithTag(offlineTag)?.removeFromSuperview()
    }
}
