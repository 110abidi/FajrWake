//
//  CustomAlarmPickerVCContainer.swift
//  Fajr Wake
//
//  Created by Ali Mir on 6/26/16.
//  Copyright © 2016 Fajr Wake. All rights reserved.
//

import UIKit

class CustomAlarmPickerVCContainer: UIViewController {
    var AddAlarmMasterVCReference: AddAlarmMasterViewController?
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var pickerTime: Date? {
        didSet {
            AddAlarmMasterVCReference?.pickerTime = pickerTime
            datePicker.date = pickerTime!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let time = AddAlarmMasterVCReference!.pickerTime {
            pickerTime = time as Date
        } else {
            print("oh dear... something went wrong in viewDidLoad() of CustomAlarmPickerVCContainer")
        }
    }
    
    @IBAction func datePickerAction(_ sender: AnyObject) {
        pickerTime = datePicker.date
    }
}
