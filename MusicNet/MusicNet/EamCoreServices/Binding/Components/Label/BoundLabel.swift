//
//  BoundLabel.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 6/3/21.
//

import Foundation
import UIKit

class BoundLabel: UILabel {
    
    var changedClosure: (() -> ())?
    
    func bind(to observable: Observable<String>) {

        changedClosure = { [weak self] in
            observable.bindingChanged(to: self?.text ?? "")
        }

        observable.valueChanged = { [weak self] newValue in
            self?.text = newValue
        }
    }
}
