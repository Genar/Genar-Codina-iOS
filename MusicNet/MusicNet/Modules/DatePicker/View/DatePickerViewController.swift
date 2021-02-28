//
//  DatePIckerViewController.swift
//  MusicNet
//
//  Created by Genaro Codina Reverter on 28/2/21.
//

import UIKit

class DatePickerViewController: UIViewController, Storyboarded  {

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    @IBAction func onDoneClicked(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
