//
//  ArticlesHeaderContainer.swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//


import UIKit
import SwiftUI

final class ArticlesHeaderContainer: UIView {

    @IBInspectable var headerTitle: String = "Articles" {
        didSet { refresh() }
    }

    /// false = list mode, true = grid mode. Updating it re-renders the SwiftUI header.
    private(set) var isGridMode: Bool = false {
        didSet { refresh() }
    }

    // Set these from the view controller
    var onGridTap: (() -> Void)?
    var onSearchTap: (() -> Void)?

    private var hosting: UIHostingController<ArticlesHeaderView>?

    /// Call once from viewDidLoad
    func attach(to parent: UIViewController) {
        guard hosting == nil else { return }

        let host = UIHostingController(rootView: makeRootView())
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false

        parent.addChild(host)
        addSubview(host.view)

        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: topAnchor),
            host.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        host.didMove(toParent: parent)
        hosting = host
    }

    /// Called by the view controller whenever the layout mode changes.
    func updateToggleIcon(isGridMode: Bool) {
        self.isGridMode = isGridMode
    }

    private func makeRootView() -> ArticlesHeaderView {
        ArticlesHeaderView(
            title: headerTitle,
            isGridMode: isGridMode,
            onGridTap: { [weak self] in self?.onGridTap?() },
            onSearchTap: { [weak self] in self?.onSearchTap?() }
        )
    }

    private func refresh() {
        hosting?.rootView = makeRootView()
    }
}
