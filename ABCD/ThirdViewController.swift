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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userName.text = userInfo.shared.fullName
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

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signInVC"{
            _ = segue.destination as! ViewController
        }
    }

}

