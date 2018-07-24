//
//  graphViewController.swift
//  ABCD
//
//  Created by admin on 7/23/18.
//  Copyright © 2018 Sarar Raad. All rights reserved.
//

import UIKit


class graphViewController: UIViewController{
    
    @IBAction func GoBack(_ sender: Any) {
        self.performSegue(withIdentifier: "FirstViewController", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FirstViewController"{
            _ = segue.destination as! FirstViewController
        }
    }
}
