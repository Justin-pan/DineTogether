//
//  ViewController.swift
//  NewLogin
//
//  Created by Austin Whitney on 2018-06-27.
//  Copyright © 2018 Austin Whitney. All rights reserved.
//

import UIKit
import GoogleSignIn
import SafariServices

class userInfo {
    static let shared = userInfo()
    var userId : String = ""                  // For client-side use only!
    var idToken : String = "" // Safe to send to the server
    var fullName : String = ""
    var givenName : String = ""
    var familyName : String = ""
    var email : String = ""
}

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, SFSafariViewControllerDelegate {
    var email: String = ""
    var givenName: String = ""
    var familyName: String = ""
    @IBOutlet weak var SignOutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func SignOut(_ sender: Any) {
        
        let url = URL(string: "https://www.google.com/accounts/Logout")!
        let controller = SFSafariViewController(url: url)
        
        self.present(controller, animated: true, completion: nil)
        controller.delegate = self
        //controller.dismiss(animated: true, completion: nil)
        GIDSignIn.sharedInstance().signOut()
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func signInWillDispatch(_signIn: GIDSignIn!, error: Error!) {
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            
            // Perform any operations on signed in user here.
            userInfo.shared.userId = user.userID                  // For client-side use only!
            userInfo.shared.idToken = user.authentication.idToken // Safe to send to the server
            userInfo.shared.fullName = user.profile.name
            userInfo.shared.givenName = user.profile.givenName
            userInfo.shared.familyName = user.profile.familyName
            userInfo.shared.email = user.profile.email
            self.performSegue(withIdentifier: "ThirdViewController", sender: self)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    @IBAction func signInButtonTouch(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().clientID="957530448682-5hq21n5uvo24qfft66r39v9mu6340bac.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().signIn()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ThirdViewController"{
            var vc = segue.destination as! ThirdViewController
        }
    }
}

