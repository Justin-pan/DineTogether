//
//  FirstViewController.swift
//  cmpt276
//
//  Created by savtozb on 2018-06-25.
//  Copyright © 2018 savtozb. All rights reserved.
//

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
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        // setup for table
        tableView.delegate = self
        tableView.dataSource = self
        if (userInfo.shared.ExpiryTime != -1)&&(CurrTime.timeIntervalSince(userInfo.shared.ExpiryDate) > userInfo.shared.ExpiryTime*60){
            userInfo.shared.LastPost = Posting(_id: "",email: "",fullName: "",date: "",time: 0,distance: 0,latitude: 0,longitude: 0, preference: "", description: "")
        }
        
        if(userInfo.shared.LastPost.time == 0){
            print("sdadsa")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.inputDialog()
            }
        
        }
        
        if (userInfo.shared.ExpiryTime != -1)&&(CurrTime.timeIntervalSince(userInfo.shared.ExpiryDate) < userInfo.shared.ExpiryTime*60){
            posts=userInfo.shared.SavePost
            self.tableView.reloadData()
        }
        view.addSubview(tableView)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FirstViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(){
        
        if(userInfo.shared.LastPost.time != 0){
            submitPost(post: userInfo.shared.LastPost) {(result) in
                switch result{
                case .success(let posts):
                    self.posts = posts
                    userInfo.shared.SavePost = posts
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print(posts)
                case.failure(let error):
                    fatalError("error: \(error)")
                }
            }
        }
        refreshControl.endRefreshing()
    }
    
    @IBAction func showGraph(_ sender: Any){
        self.performSegue(withIdentifier: "Showgraph", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Showgraph"{
            _ = segue.destination as! graphViewController
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
        cell.detailTextLabel?.numberOfLines = 2
        cell.detailTextLabel?.text = "Available until: " + String(posts[row].date) + "\nMaximum distance: " + String(posts[row].distance) + "km"
        
        return cell
    }
    
    // cell tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        let restrictionNames = ["Vegetarian", "Vegan", "Pescatarian", "Halal", "Gluten-Free", "Diabetic"]
        let allergyNames = ["Milk", "Nut", "Eggs", "Soy"]
        let preferenceArray = posts[row].preference.flatMap{Int(String($0))}
        
        //start building the restriciton/allergy strings to display in posting alert
        var actualRestrictionsArr: [String] = []
        actualRestrictionsArr.append("\n\nRestrictions:")
        var actualAllergyArr: [String] = []
        actualAllergyArr.append("\n\nAllergies:")
        
        //add restr/allergy onto the strings
        for (index, element) in preferenceArray.enumerated() {
            if(element == 1 && index < 6) {
                actualRestrictionsArr.append(restrictionNames[index])
            }
            if(element == 1 && index >= 6) {
                actualAllergyArr.append(allergyNames[index - 6])
            }
            
        }
        
        // if there were no restrictions/allergies, dump the contents so we print nothing
        var restrictionMessage = actualRestrictionsArr.joined(separator: "\n- ")
        if (actualRestrictionsArr.count == 1){
            restrictionMessage = ""
        }
        var allergyMessage = actualAllergyArr.joined(separator: "\n- ")
        if (actualAllergyArr.count == 1){
            allergyMessage = ""
        }
        
        
        let alert = UIAlertController(title: "Posting by\n\(posts[row].fullName)\n(\(posts[row].email))",
            message: "At a maximum distance of \(posts[row].distance)km\nEating for \(posts[row].time) more minutes." + restrictionMessage + allergyMessage + "\n\nDescription:" + posts[row].description,
            preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Message", style: .default, handler: {(Action) -> Void in
            SocketIOManager.SharedInstance.defaultSocket.emit("joinRoom", self.posts[row].email)
            if roomManager.SharedInstance.roomList.contains(where: {$0.roomName == self.posts[row].email}){
                
            }else{
                let room = rooms(roomName: self.posts[row].email, roomId: self.posts[row].fullName)
                roomManager.SharedInstance.roomList.append(room)
                //room should have another name for appearance purposes todo
                let friend = sendingFriend(userId: userInfo.shared.email, friendName: room.roomName, friendId: room.roomId)
                sendFriend(friend: friend){(error) in
                    if let error = error{
                        fatalError("error: \(error)")
                    }
                }
            }
            let childVC:ChatViewController = ChatViewController()
            childVC.roomName = self.posts[row].email
            childVC.roomId = self.posts[row].fullName
            self.addChildViewController(childVC)
            self.view.addSubview(childVC.view)
            childVC.didMove(toParentViewController: self)
            childVC.becomeFirstResponder()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        print(posts[row])
    }
    
    //input dialog for creating posts
    func inputDialog(){
        //creating the alert controller
        let alert = UIAlertController(title: "Share a new post", message: "Please confirm how long you're available for, and the distance you're willing to travel.", preferredStyle: .alert)
        //actions to be done in the alert controller
        let cancelAction = Action.init(title: "Cancel", style: .default, handler: {(Action) -> Void in
            self.actionString = "Cancel"
        })
        let saveAction = Action.init(title:"Done", style: .default, handler: {(Action) -> Void in
            self.actionString = "Done"
            if CLLocationManager.locationServicesEnabled(){
                switch CLLocationManager.authorizationStatus(){
                case .notDetermined, .restricted, .denied:
                    let newAlert = UIAlertController(title: "No location", message: "You did not allow location services, this is important to the usage of the app. You can allow this in the app settings, then restart the app.", preferredStyle: .alert)
                    self.present(newAlert, animated: true, completion: nil)
                case .authorizedAlways, .authorizedWhenInUse:
                    //creating the posting and formatting and such
                    let time = alert.textFields![0].text
                    userInfo.shared.ExpiryTime = Double(time!)!
                    let distance = alert.textFields![1].text
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "eeee, h:mm a"
                    let newDate = Calendar.current.date(byAdding: .minute, value: Int(time!)!, to: date)
                    let formattedNewDate = formatter.string(from: newDate!)
                    let myPost = Posting(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, date: formattedNewDate, time: Int(time!)!, distance: Int(distance!)!, latitude: self.userLocation.coordinate.latitude, longitude: self.userLocation.coordinate.longitude, preference: userInfo.shared.preferenceString, description: userInfo.shared.description)
                    print(myPost)
                    userInfo.shared.LastPost = myPost
                    
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
                            if roomManager.SharedInstance.roomList.contains(where: {$0.roomName == userInfo.shared.email}){
                                
                            } else {
                                let room  = rooms(roomName: userInfo.shared.email, roomId: userInfo.shared.fullName)
                                roomManager.SharedInstance.roomList.insert(room, at: 0)
                                let friend = sendingFriend(userId: userInfo.shared.email, friendName: room.roomName, friendId: room.roomId)
                                sendFriend(friend: friend){(error) in
                                    if let error = error{
                                        fatalError("error: \(error)")
                                    }
                                }
                            }
                            SocketIOManager.SharedInstance.defaultSocket.emit("joinRoom", userInfo.shared.email)
                        case.failure(let error):
                            fatalError("error: \(error)")
                        }
                    }
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

