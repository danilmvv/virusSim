//
//  PersonCell.swift
//  virusSim
//
//  Created by Danil Masnaviev on 27/03/24.
//

import Foundation
import UIKit

class PersonCell: UICollectionViewCell {
    let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for isSick: Bool) {
        if isSick {
            iconImageView.image = UIImage(systemName: "allergens")
            iconImageView.tintColor = .black
        } else {
            iconImageView.image = nil
        }
    }
}
