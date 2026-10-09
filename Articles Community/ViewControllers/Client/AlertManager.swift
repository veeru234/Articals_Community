//
//  AlertManager.swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//

import UIKit
import Foundation

//final class AlertManager {
//
//    static let shared = AlertManager()
//
//    private init() {}
//
//
//        func showAlert(title: String, message: String) {
//            DispatchQueue.main.async { [weak self] in
//                guard let self, self.viewIfLoaded?.window != nil else { return }
//
//                var top: UIViewController = self
//                while let presented = top.presentedViewController { top = presented }
//
//                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
//                top.present(alert, animated: true)
//            }
//    }
//}

extension UIViewController {

    func showAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self, self.viewIfLoaded?.window != nil else { return }

            var top: UIViewController = self
            while let presented = top.presentedViewController { top = presented }

            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            top.present(alert, animated: true)
        }
    }
}
