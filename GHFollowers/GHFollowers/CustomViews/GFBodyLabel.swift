//
//  GFBodyLabel.swift
//  GHFollowers
//
//  Created by Алексей Зубель on 17.02.26.
//

import UIKit

class GFBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        self.textColor = .secondaryLabel
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.75
        self.lineBreakMode = .byWordWrapping
    }
}
