//
//  UIApplication++.swift
//  SampleLearning
//
//  Created by Shashi Gupta on 02/08/24.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing(_ force: Bool) {
        guard let windowScene = connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows
            .filter { $0.isKeyWindow }
            .first?
            .endEditing(force)
    }
}
