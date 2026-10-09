//
//  UIView .swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//

import Foundation
import UIKit

extension UIView {

    @IBInspectable
    var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable
    var clipToBounds: Bool {
        get {
            clipsToBounds
        }
        set {
            clipsToBounds = newValue
        }
    }
    
    
}
