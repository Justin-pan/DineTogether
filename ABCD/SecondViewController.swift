//
//  SecondViewController.swift
//  cmpt276
//
//  Created by savtozb on 2018-06-25.
//  Copyright © 2018 savtozb. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var tableView: UITableView!
    let textCellIdentifier = "TextCell"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomManager.SharedInstance.roomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = roomManager.SharedInstance.roomList[row].roomId + "'s room"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        SocketIOManager.SharedInstance.defaultSocket.emit("joinRoom", roomManager.SharedInstance.roomList[row].roomName)
        let childVC:ChatViewController = ChatViewController()
        childVC.roomName = roomManager.SharedInstance.roomList[row].roomName
        childVC.roomId = roomManager.SharedInstance.roomList[row].roomId
        self.addChildViewController(childVC)
        self.view.addSubview(childVC.view)
        childVC.didMove(toParentViewController: self)
        childVC.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

