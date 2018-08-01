//
//  ThirdViewController.swift
//  cmpt276
//
//  Created by savtozb on 2018-06-25.
//  Copyright © 2018 savtozb. All rights reserved.
//

import UIKit
import GoogleSignIn
import SafariServices

class ThirdViewController: UIViewController,SFSafariViewControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var SignOutButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var veganButton: UIButton!
    @IBOutlet weak var pescatarianButton: UIButton!
    @IBOutlet weak var halalButton: UIButton!
    @IBOutlet weak var GlutenFreeButton: UIButton!
    @IBOutlet weak var DiabeticButton: UIButton!
    @IBOutlet weak var vegetarianButton: UIButton!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var bioButton: UIButton!
    @IBOutlet weak var milkButton: UIButton!
    @IBOutlet weak var nutsButton: UIButton!
    @IBOutlet weak var eggsButton: UIButton!
    @IBOutlet weak var soyButton: UIButton!
    
    var preference: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        
        self.bioText.delegate = self
        preference = userInfo.shared.savedpreferences
        // Do any additional setup after loading the view, typically from a nib.
        bioButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
        userName.text = userInfo.shared.fullName
        bioText.text = userInfo.shared.description
        bioText.textColor = UIColor.darkGray
        if preference[0] == 1 {
            vegetarianButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            vegetarianButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
            
        }else{
            preference[0] = 0
            vegetarianButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            vegetarianButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        if preference[1] == 1 {
            veganButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            veganButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
            
        }else{
            veganButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            veganButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        if preference[2] == 1 {
            pescatarianButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            pescatarianButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
            
        }else{
            pescatarianButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            pescatarianButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        if preference[3] == 1 {
            halalButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            halalButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
            
        }else{
            halalButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            halalButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        if preference[4] == 1 {
            GlutenFreeButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            GlutenFreeButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
            
        }else{
            GlutenFreeButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            GlutenFreeButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        if preference[5] == 1 {
            DiabeticButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            DiabeticButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
            
        }else{
            DiabeticButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            DiabeticButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        if preference[6] == 1 {
            milkButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            milkButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
            
        }else{
            milkButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            milkButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        if preference[7] == 1 {
            nutsButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            nutsButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
            
        }else{
            nutsButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            nutsButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        if preference[8] == 1 {
            eggsButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            eggsButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
            
        }else{
            eggsButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            eggsButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        if preference[9] == 1 {
            soyButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            soyButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
            
        }else{
            soyButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            soyButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logout(_ sender: Any) {
        self.performSegue(withIdentifier: "signInVC", sender:SignOutButton  )
        //      let url = URL(string: "https://www.google.com/accounts/Logout")!
        //      let controller = SFSafariViewController(url: url)
        //      self.present(controller, animated: true, completion: nil)
        //      controller.delegate = self
        //      controller.dismiss(animated: true, completion: nil)
        GIDSignIn.sharedInstance().signOut()
        SocketIOManager.SharedInstance.defaultSocket.disconnect()
        userInfo.shared.SavePost = []
        userInfo.shared.LastPost = Posting(_id: "",email: "",fullName: "",date: "",time: 0,distance: 0,latitude: 0,longitude: 0, preference: "",description: "")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= 140
    }
    @IBAction func VegetarianEnabled(_ sender: Any) {
        if preference[0] == 0 {
            preference[0] = 1
            userInfo.shared.savedpreferences[0] = 1
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            vegetarianButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            vegetarianButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
        }
        else{
            preference[0] = 0
            userInfo.shared.savedpreferences[0] = 0
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            vegetarianButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            vegetarianButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: userInfo.shared.description, preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
    }
    
    @IBAction func VeganEnabled(_ sender: Any) {
        if preference[1] == 0 {
            preference[1] = 1
            userInfo.shared.savedpreferences[1] = 1
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            veganButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            veganButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
        }
        else{
            preference[1] = 0
            userInfo.shared.savedpreferences[1] = 0
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            veganButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            veganButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: userInfo.shared.description, preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
        
    }
    
    @IBAction func PescatarianEnabled(_ sender: Any) {
        if preference[2] == 0 {
            preference[2] = 1
            userInfo.shared.savedpreferences[2] = 1
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            pescatarianButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            pescatarianButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
        }
        else{
            preference[2] = 0
            userInfo.shared.savedpreferences[2] = 0
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            pescatarianButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            pescatarianButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: userInfo.shared.description, preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
    }
    
    @IBAction func HalalEnabled(_ sender: Any) {
        if preference[3] == 0 {
            preference[3] = 1
            userInfo.shared.savedpreferences[3] = 1
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            halalButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            halalButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
        }
        else{
            preference[3] = 0
            userInfo.shared.savedpreferences[3] = 0
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            halalButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            halalButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: userInfo.shared.description, preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
    }
    
    @IBAction func GlutenFreeEnabled(_ sender: Any) {
        if preference[4] == 0 {
            preference[4] = 1
            userInfo.shared.savedpreferences[4] = 1
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            GlutenFreeButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            GlutenFreeButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
        }
        else{
            preference[4] = 0
            userInfo.shared.savedpreferences[4] = 0
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            GlutenFreeButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            GlutenFreeButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: userInfo.shared.description, preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
    }
    
    @IBAction func DiabeticEnabled(_ sender: Any) {
        if preference[5] == 0 {
            preference[5] = 1
            userInfo.shared.savedpreferences[5] = 1
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            DiabeticButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            DiabeticButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)

        }
        else{
            preference[5] = 0
            userInfo.shared.savedpreferences[5] = 0
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            DiabeticButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            DiabeticButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: userInfo.shared.description, preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
 
    }
    
    @IBAction func milkEnabled(_ sender: Any) {
        if preference[6] == 0 {
            preference[6] = 1
            userInfo.shared.savedpreferences[6] = 1
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            milkButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            milkButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
            
        }
        else{
            preference[6] = 0
            userInfo.shared.savedpreferences[6] = 0
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            milkButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            milkButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: userInfo.shared.description, preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
    }
    
    @IBAction func nutsEnabled(_ sender: Any) {
        if preference[7] == 0 {
            preference[7] = 1
            userInfo.shared.savedpreferences[7] = 1
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            nutsButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            nutsButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
            
        }
        else{
            preference[7] = 0
            userInfo.shared.savedpreferences[7] = 0
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            nutsButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            nutsButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: userInfo.shared.description, preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
    }
    
    @IBAction func eggsEnabled(_ sender: Any) {
        if preference[8] == 0 {
            preference[8] = 1
            userInfo.shared.savedpreferences[8] = 1
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            eggsButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            eggsButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
            
        }
        else{
            preference[8] = 0
            userInfo.shared.savedpreferences[8] = 0
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            eggsButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            eggsButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: userInfo.shared.description, preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
    }
    @IBAction func soyEnabled(_ sender: Any) {
        if preference[9] == 0 {
            preference[9] = 1
            userInfo.shared.savedpreferences[9] = 1
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            soyButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            soyButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
            
        }
        else{
            preference[9] = 0
            userInfo.shared.savedpreferences[9] = 0
            userInfo.shared.preferenceString = String(preference.flatMap{String($0)})
            soyButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            soyButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: userInfo.shared.description, preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
    }
    
    @IBAction func updateBio(_ sender: Any) {
        print(bioText.text!)
        userInfo.shared.description = bioText.text!
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: userInfo.shared.description, preference: userInfo.shared.preferenceString)
        updateDescription(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signInVC"{
            _ = segue.destination as! ViewController
        }
    }
    
}


