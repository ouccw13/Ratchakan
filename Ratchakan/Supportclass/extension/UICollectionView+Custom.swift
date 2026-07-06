//
//  UICollectionView+Custom.swift
//  ratchakan
//
//  Created by JJsobtid on 5/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
	func setUp(_ parent: Any, bg: UIColor, inset: UIEdgeInsets = UIEdgeInsets(top: MARGIN, left: MARGIN, bottom: MARGIN, right: MARGIN)) {
		delegate = parent as? UICollectionViewDelegate
		dataSource = parent as? UICollectionViewDataSource
		contentInset = inset
		backgroundColor = bg
	}
	
	func hideScrollIndicatior() {
		showsVerticalScrollIndicator = false
		showsHorizontalScrollIndicator = false
	}
	
	func canScroll(_ can: Bool) {
		isScrollEnabled = can
	}
    
    func reloadItems(inSection section:Int) {
       reloadItems(at: (0..<numberOfItems(inSection: section)).map {
          IndexPath(item: $0, section: section)
       })
    }
    
    func regis(nibName: String) {
        register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
    
    func regis(nibName: String, forSupplementaryViewOfKind kind: String) {
        register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: nibName)
    }
}
