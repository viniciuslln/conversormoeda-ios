//
//  LeftAlignedIconButton.swift
//  Conversor de moeda
//
//  Created by vinicius dev on 22/12/19.
//  Copyright © 2019 vinicius dev. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class LeftAlignedIconButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagePadding: CGFloat = 30.0
        guard let imageViewWidth = self.imageView?.frame.width else{return}
        guard let titleLabelWidth = self.titleLabel?.intrinsicContentSize.width else{return}
        self.contentHorizontalAlignment = .left
        imageEdgeInsets = UIEdgeInsets(top: 16.0, left: imagePadding - imageViewWidth / 2, bottom: 16.0, right: 0.0)
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: (bounds.width - titleLabelWidth) / 2 - imageViewWidth, bottom: 0.0, right: 0.0)
        imageView?.contentMode = .scaleAspectFit
    }
}
