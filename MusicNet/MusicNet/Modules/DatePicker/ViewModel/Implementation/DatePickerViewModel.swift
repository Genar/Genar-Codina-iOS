//
//  DatePickerViewModel.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 14/3/21.
//

import Foundation

class DatePickerViewModel: DatePickerViewModelProtocol {
    
    var delegate: RangeDatesProtocol?
    
    var coordinatorDelegate: DatePickerViewModelCoordinatorDelegate?
    
    func dismiss() {
        
        self.coordinatorDelegate?.dismiss()
    }
}
