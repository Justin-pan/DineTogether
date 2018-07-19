//
//  FirstViewController.swift
//  cmpt276
//
//  Created by savtozb on 2018-06-25.
//  Copyright © 2018 savtozb. All rights reserved.
// test commit comment

import UIKit
import CoreLocation
import MessageKit

class FirstViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    // setup for table
    @IBOutlet var tableView: UITableView!
    let textCellIdentifier = "TextCell"
    var posts = [Posting]()
    var locationManager = CLLocationManager()
    var userLocation: CLLocation!
    var Action = UIAlertAction.self
    var actionString: String?
    let CurrTime = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        // setup for table
        tableView.delegate = self
        tableView.dataSource = self
        if (userInfo.shared.ExpiryTime != -1)&&(CurrTime.timeIntervalSince(userInfo.shared.ExpiryDate) < userInfo.shared.ExpiryTime*60){
            posts=userInfo.shared.SavePost
            self.tableView.reloadData()
        }
    }
    
    // posting list width in UI
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // posting list length in UI
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // populate cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = posts[row].fullName
        cell.detailTextLabel?.text = "Time: " + String(posts[row].time)
        
        return cell
    }
    
    // cell tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        
        let alert = UIAlertController(title: "Posting by \(posts[row].email)",
                                      message: "Distance: \(posts[row].distance) KM\n Time: \(posts[row].time)\n",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Message", style: .default, handler: {(Action) -> Void in
            let childVC = MessagesViewController()
            self.addChildViewController(childVC)
            self.view.addSubview(childVC.view)
            childVC.didMove(toParentViewController: self)
            self.becomeFirstResponder()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        print(posts[row])
    }
    
    //input dialog for creating posts
    func inputDialog(){
        //creating the alert controller
        let alert = UIAlertController(title: "Posting details", message: "Please choose how long you are willing to wait from now and a distance at which others can see your post", preferredStyle: .alert)
        //actions to be done in the alert controller
        let cancelAction = Action.init(title: "Cancel", style: .default, handler: {(Action) -> Void in
            self.actionString = "Cancel"
        })
        let saveAction = Action.init(title:"Done", style: .default, handler: {(Action) -> Void in
            self.actionString = "Done"
            
            //creating the posting and formatting and such
            let time = alert.textFields![0].text
            userInfo.shared.ExpiryTime = Double(time!)!
            let distance = alert.textFields![1].text
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "eeee, h:m a"
            let newDate = Calendar.current.date(byAdding: .minute, value: Int(time!)!, to: date)
            let formattedNewDate = formatter.string(from: newDate!)
            let myPost = Posting(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, date: formattedNewDate, time: Int(time!)!, distance: Int(distance!)!, latitude: self.userLocation.coordinate.latitude, longitude: self.userLocation.coordinate.longitude)
            print(myPost)
            
            
            //submitting the post
            submitPost(post: myPost) {(result) in
                switch result{
                case .success(let posts):
                    self.posts = posts
                    userInfo.shared.ExpiryDate = Date()
                    userInfo.shared.SavePost = posts
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print(posts)
                case.failure(let error):
                    fatalError("error: \(error)")
                }
            }
            
        })
        //disable saveaction until its only ints in the text dialogs
        saveAction.isEnabled = false
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Time in minutes"
            textField.keyboardType = .numberPad
            //check when this changes for whether or not the text is int
            textField.addTarget(alert, action: #selector(alert.textDidChangeInPostAlert), for: .editingChanged)
        })
        
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Distance in kilometers"
            textField.keyboardType = .numberPad
            //check when this changes for whether or not the text is int
            textField.addTarget(alert, action: #selector(alert.textDidChangeInPostAlert), for: .editingChanged)
        })
        //adding all the actions
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
extension UIAlertController{
    func isValidLocation(_ location: String) -> Bool{
        //return whether or not the textfield holds int
        return location.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 && Int(location) != nil
    }
    func isValidTime(_ time: String) -> Bool{
        //return whether or not the textfield holds int
        return time.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 && Int(time) != nil
    }
    @objc func textDidChangeInPostAlert(){
        if let time = textFields?[0].text,
        let location = textFields?[1].text,
        let action = actions.first{
            //sets save action to whether or not both of these have ints
            action.isEnabled = isValidLocation(location) && isValidTime(time)
        }
    }
}
