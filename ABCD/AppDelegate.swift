//
//  AppDelegate.swift
//  NewLogin
//
//  Created by Austin Whitney on 2018-06-27.
//  Copyright © 2018 Austin Whitney. All rights reserved.
//

import UIKit
import GoogleSignIn
import MessageKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    

    var window: UIWindow?
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "eeee, h:mm a"
        return formatter
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        if #available(iOS 9.0, *) {
            return GIDSignIn.sharedInstance().handle(url as URL?, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication.rawValue] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation.rawValue] as? String)
        } else {
            // Fallback on earlier versions
        }
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url as URL?,sourceApplication: sourceApplication,annotation: annotation)
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        GIDSignIn.sharedInstance().signOut()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        GIDSignIn.sharedInstance().signOut()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }
    //This is where the user connects to the server using socket io
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        SocketIOManager.SharedInstance.defaultSocket.connect()
        //this is just to check whether or not the user disconnected without completely closing the app
        if userInfo.shared.fullName.isEmpty{
        }else{
            //emit a reconnect event if this is true
            SocketIOManager.SharedInstance.defaultSocket.emit("reconnect", userInfo.shared.fullName)
        }
        //This is a handler for messages to accept messages everywhere on the app, without having to be in the message view controller
        SocketIOManager.SharedInstance.defaultSocket.on("message"){[weak self] data, ack in
            print("Is this happening?")
            if let room = roomManager.SharedInstance.roomList.first(where: {$0.roomName == data[0] as? String}){
                if let text: String = data[1] as? String, let id = data[2] as? String, let name = data[3] as? String, let date = data[4] as? String, let messageID = data[5] as? String{
                    let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
                    let sender: Sender = Sender(id: id, displayName: name)
                    let sendDate = self?.formatter.date(from: date)
                    let message = Message(attributedText: attributedText, sender: sender, messageId: messageID, date: sendDate!)
                    room.messageList.append(message)
                }
            }else{
                print("This should never happen")
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        GIDSignIn.sharedInstance().signOut()
        //disconnect on signout
        SocketIOManager.SharedInstance.defaultSocket.disconnect()
    }


}


