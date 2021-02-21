//
//  BoundTextField.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 21/2/21.
//

import Foundation
import UIKit

class BoundTextField: UITextField {
    
    var changedClosure: (() -> ())?
    
    func bind(to observable: Observable<String>) {
        
        addTarget(self, action: #selector(BoundTextField.valueChanged), for: .editingChanged)

        changedClosure = { [weak self] in
            observable.bindingChanged(to: self?.text ?? "")
        }

        observable.valueChanged = { [weak self] newValue in
            self?.text = newValue
        }
    }
    
    @objc func valueChanged() {
        
        changedClosure?()
    }
}
