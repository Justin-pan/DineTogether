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

class ThirdViewController: UIViewController,SFSafariViewControllerDelegate {
    
    @IBOutlet weak var SignOutButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var veganButton: UIButton!
    @IBOutlet weak var pescatarianButton: UIButton!
    @IBOutlet weak var halalButton: UIButton!
    @IBOutlet weak var GlutenFreeButton: UIButton!
    @IBOutlet weak var DiabeticButton: UIButton!
    @IBOutlet weak var vegetarianButton: UIButton!

    var preference: [Int] = [0,0,0,0,0,0,0,0,0,0]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        preference = userInfo.shared.savedpreferences
        // Do any additional setup after loading the view, typically from a nib.
        userName.text = userInfo.shared.fullName
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
        userInfo.shared.SavePost = []
        userInfo.shared.LastPost = Posting(_id: "",email: "",fullName: "",date: "",time: 0,distance: 0,latitude: 0,longitude: 0, preference: "")
    }
    

    @IBAction func VegetarianEnabled(_ sender: Any) {
        if preference[0] == 0 {
            preference[0] = 1
            vegetarianButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            vegetarianButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
        }
        else{
            preference[0] = 0
            vegetarianButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            vegetarianButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: "", preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
    }
    
    @IBAction func VeganEnabled(_ sender: Any) {
        if preference[1] == 0 {
            preference[1] = 1
            veganButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            veganButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
        }
        else{
            preference[1] = 0
            veganButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            veganButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: "", preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
        
    }
    
    @IBAction func PescatarianEnabled(_ sender: Any) {
        if preference[2] == 0 {
            preference[2] = 1
            pescatarianButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            pescatarianButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
        }
        else{
            preference[2] = 0
            pescatarianButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            pescatarianButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: "", preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
    }
    
    @IBAction func HalalEnabled(_ sender: Any) {
        if preference[3] == 0 {
            preference[3] = 1
            halalButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            halalButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
        }
        else{
            preference[3] = 0
            halalButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            halalButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: "", preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
    }
    
    @IBAction func GlutenFreeEnabled(_ sender: Any) {
        if preference[4] == 0 {
            preference[4] = 1
            GlutenFreeButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            GlutenFreeButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)
        }
        else{
            preference[4] = 0
            GlutenFreeButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            GlutenFreeButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: "", preference: stringArray)
        updatePreference(user: user){(error) in
            if let error = error{
                fatalError("error: \(error)")
            }
        }
    }
    
    @IBAction func DiabeticEnabled(_ sender: Any) {
        if preference[5] == 0 {
            preference[5] = 1
            DiabeticButton.setTitleColor(UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1), for: .normal)
            DiabeticButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha: 1)

        }
        else{
            preference[5] = 0
            DiabeticButton.setTitleColor(UIColor(red:0,green:122/255,blue:1,alpha: 1), for: .normal)
            DiabeticButton.backgroundColor = UIColor(red:255/255,green:255/255,blue:255/255,alpha: 1)
        }
        let stringArray = String(preference.flatMap{String($0)})
        let user = User(_id: "", email: userInfo.shared.email, fullName: userInfo.shared.fullName, description: "", preference: stringArray)
        updatePreference(user: user){(error) in
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


