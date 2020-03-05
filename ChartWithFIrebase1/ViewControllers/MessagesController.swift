//
//  ViewController.swift
//  ChartWithFIrebase1
//
//  Created by kyucraquispe on 2/28/20.
//  Copyright © 2020 kyucraquispe. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Message", style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        self.present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        //user is not logged in
        guard let uid = Auth.auth().currentUser?.uid else {
            handleLogout()
            return
        }
        
        Database.database().reference().child("users").child(uid).observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("calling viewDidAppear")
    }
    
    @objc func handleLogout() {
        // try to logout
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        loginController.callbackClosure = { [weak self] in
            self?.checkIfUserIsLoggedIn()
        }
        //Ask Tom why this have a strange behavior. Video1 : min 10
        self.present(loginController, animated: true, completion: nil)
        
    }


}

