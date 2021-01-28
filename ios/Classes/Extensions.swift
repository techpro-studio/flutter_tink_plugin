//
//  Extensions.swift
//  tink_plugin
//
//  Created by Alex on 28.01.2021.
//

import Foundation
import UIKit

extension UIView {
    var ltr: Bool{
        if #available(iOS 9.0, *) {
            return UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .leftToRight
        } else {
            return true;
        }
    }

    func fill(in view: UIView, insets: UIEdgeInsets = .zero){
        view.addSubview(self)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: insets.top),
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: view.ltr ? insets.left : insets.right),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: view.ltr ? insets.right : insets.left),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: insets.bottom)
        ])
    }
}
