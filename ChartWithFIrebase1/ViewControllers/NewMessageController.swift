//
//  newMessageController.swift
//  ChartWithFIrebase1
//
//  Created by kyucraquispe on 3/3/20.
//  Copyright © 2020 kyucraquispe. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let cellId = "cellId"
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUsers()
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let name = dictionary["name"] as? String, email = dictionary["email"] as? String, profileImageUrl = dictionary["profileImageUrl"] as? String
                let user = User()
                user.name = name
                user.email = email
                user.profileImageUrl = profileImageUrl
                
                self.users.append(user)
                
                //ask tom about it
                self.tableView.reloadData()
            }
        }
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
}

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //textLabel?.frame = CGRectMake(56, textLabel?.frame.origin.y, textLabel?.frame.origin.width, textLabel?.frame.origin.height  )
        if let textLabel = textLabel, let detailTextLabel = detailTextLabel {
            print(textLabel.frame)
            //textLabel.frame = CGRect(x: 56, y: textLabel.frame.origin.y, width: textLabel.frame.size.width, height: textLabel.frame.size.width)
            textLabel.frame.origin.x = 64
            textLabel.frame.origin.y -= 2
            
            detailTextLabel.frame.origin.x = 64
            detailTextLabel.frame.origin.y += 2
        }
        
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "master")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        addConstraintsToProfileImageView()
        
    }
    
    func addConstraintsToProfileImageView() {
        //need x, y, with, height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
