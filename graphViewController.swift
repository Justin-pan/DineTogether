
//  graphViewContoller.swift
//  ABCD
//
//  Created by admin on 7/23/18.
//  Copyright © 2018 Sarar Raad. All rights reserved.
//

import UIKit
import Charts
class graphViewController: UIViewController{
    
    @IBAction func goBack(_ sender: Any){
        self.performSegue(withIdentifier: "Backtopost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Backtopost"{
            _ = segue.destination as! FirstViewController
        }
    }
}

