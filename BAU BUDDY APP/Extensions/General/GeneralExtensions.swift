//
//  GeneralExtensions.swift
//  BAU BUDDY APP
//
//  Created by Macbook Air on 7.03.2023.
//

import Foundation
import UIKit

extension UIView {
    func addSubViews(_ views : [UIView]) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
}
