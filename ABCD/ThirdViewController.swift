//
//  ThirdViewController.swift
//  cmpt276
//
//  Created by savtozb on 2018-06-25.
//  Copyright © 2018 savtozb. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    var email: String = ""
    var familyName: String = ""
    var givenName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(tabSwiper(_ : )))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(tabSwiper(_ : )))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func tabSwiper(_ sender : UISwipeGestureRecognizer) {
        if sender.direction == .left {
            self.tabBarController!.selectedIndex = min(2, self.tabBarController!.selectedIndex + 1)
        }
        
        if sender.direction == .right {
            self.tabBarController!.selectedIndex = 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userName.text = givenName
    }
}


