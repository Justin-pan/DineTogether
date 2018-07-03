//
//  FirstViewController.swift
//  cmpt276
//
//  Created by savtozb on 2018-06-25.
//  Copyright © 2018 savtozb. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate{
    func inputDialog(){
        let alert = UIAlertController(title: "Posting details", message: "Please choose how long you are willing to wait from now and a distance at which others can see your post", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction) in})
        let saveAction = UIAlertAction(title:"Done", style: .default, handler: {(action: UIAlertAction) in
            let date = Date()
            let calendar = Calendar.current
            var hour = calendar.component(.hour, from: date)
            var minutes = calendar.component(.minute, from: date)
            let time = alert.textFields![0].text
            let distance = alert.textFields![0].text
            var nextTime = (Int(time!)! + minutes)
            if(nextTime > 60){
                hour += 1
                nextTime = nextTime % 60
            }
            print("Time of post expiry is: \(hour):\(nextTime) and distance is \(distance)")
        })
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Time in minutes"
            textField.keyboardType = .numberPad
        })
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Distance in kilometers"
            textField.keyboardType = .numberPad
        })
        let textField1 = alert.textFields?.first
        let textField2 = alert.textFields?.last
        textField1?.delegate = self
        textField2?.delegate = self
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addPostsTouch(_ sender: Any) {
        print("button has been pressed")
        inputDialog()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != "" || string != "" {
            let res = (textField.text ?? "") + string
            return Int(res) != nil
        }
        return true
    }
}

