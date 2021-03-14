//
//  DatePickerViewModelProtocol.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 14/3/21.
//

import Foundation

protocol DatePickerViewModelProtocol {
    
    var delegate: RangeDatesProtocol? { get set }
    
    var coordinatorDelegate: DatePickerViewModelCoordinatorDelegate? { get set }
    
    func dismiss()
}
