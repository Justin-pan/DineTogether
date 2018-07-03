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
    var posts = [Posting]()
    var locationManager = CLLocationManager()
    var userLocation: CLLocation!
    func inputDialog(){
        let alert = UIAlertController(title: "Posting details", message: "Please choose how long you are willing to wait from now and a distance at which others can see your post", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction) in})
        let saveAction = UIAlertAction(title:"Done", style: .default, handler: {(action: UIAlertAction) in
            let time = alert.textFields![0].text
            let distance = alert.textFields![0].text
            let myPost = Posting(userEmail: userInfo.shared.email, time: Int(time!)!, distance: Int(distance!)!, latitude: self.userLocation.coordinate.latitude, longitude: self.userLocation.coordinate.longitude)
            print(myPost)
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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        inputDialog()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != "" || string != "" {
            let res = (textField.text ?? "") + string
            return Int(res) != nil
        }
        return true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations.last!
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clErr = error as? CLError {
            switch clErr {
            case CLError.locationUnknown:
                print("location unknown")
            case CLError.denied:
                print("denied")
            default:
                print("other Core Location error")
            }
        } else {
            print("other error:", error.localizedDescription)
        }
    }

}
