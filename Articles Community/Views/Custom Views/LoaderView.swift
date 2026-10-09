//
//  LoaderView.swift
//  Articles Community
//
//  Created by Veeru Masal on 09/10/26.
//


import UIKit

final class LoaderManager {

    static let shared = LoaderManager()
    private init() {}

    private var activeRequests = 0
    private var overlay: UIView?

    func show() {
        onMain {
            self.activeRequests += 1
            guard self.overlay == nil, let window = Self.keyWindow else { return }

            let overlay = UIView(frame: window.bounds)
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.35)

            let spinner = UIActivityIndicatorView(style: .large)
            spinner.color = .white
            spinner.center = overlay.center
            spinner.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin,
                                        .flexibleLeftMargin, .flexibleRightMargin]
            spinner.startAnimating()
            overlay.addSubview(spinner)

            window.addSubview(overlay)
            self.overlay = overlay
        }
    }

    func hide() {
        onMain {
            self.activeRequests = max(0, self.activeRequests - 1)
            guard self.activeRequests == 0 else { return }
            self.overlay?.removeFromSuperview()
            self.overlay = nil
        }
    }

    // MARK: - Helpers

    private func onMain(_ work: @escaping () -> Void) {
        Thread.isMainThread ? work() : DispatchQueue.main.async(execute: work)
    }

    private static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
