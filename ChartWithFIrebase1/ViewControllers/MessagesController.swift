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
                let user = User()
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.setupNavbarWithUser(user: user)
            }
        }
    }
    
    func setupNavbarWithUser(user: User) {
        //self.navigationItem.title = user.name
        
        let titleView = UIView()
        
        var dinamicWidth = CGFloat(integerLiteral: 100)
        if let sizeOfName = user.name?.width(withConstrainedHeight: titleView.frame.size.height, font: UILabel().font) {
            dinamicWidth = sizeOfName + CGFloat(integerLiteral: 56)
        }
        titleView.frame = CGRect(x: 0, y: 0, width: dinamicWidth, height: 40)
        
        self.navigationItem.titleView = titleView
        
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        titleView.addSubview(profileImageView)
        
        //Constraints for profileImageView, needs: x, y, height and width
        profileImageView.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(nameLabel)
        
        //Constraints for nameLabel, needs: x, y, height and width
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        
        
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    
    @objc func showChatController() {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewLayout())
        navigationController?.pushViewController(chatLogController, animated: true)
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

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
