//
//  BoundButton.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 7/3/21.
//

import Foundation
import UIKit

class BoundButton: UIButton {
    
    var changedClosure: (() -> ())?
    
    func bind(to observable: Observable<String>) {
        
        addTarget(self, action: #selector(BoundButton.valueChanged), for: .editingChanged)

        changedClosure = { [weak self] in
            observable.bindingChanged(to: self?.titleLabel?.text ?? "")
        }

        observable.valueChanged = { [weak self] newValue in
            self?.setTitle(newValue, for: .normal)
        }
    }
    
    @objc func valueChanged() {
        
        changedClosure?()
    }
}
