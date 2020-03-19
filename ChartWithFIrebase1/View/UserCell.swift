//
//  UserCell.swift
//  ChartWithFIrebase1
//
//  Created by kyucraquispe on 3/9/20.
//  Copyright © 2020 kyucraquispe. All rights reserved.
//

import UIKit
import Firebase


class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            setupNameAndProfileImage()
            
            self.detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
        }
    }
    
    private func setupNameAndProfileImage() {
        let chatPartnerId: String?
        
        if message?.toId == Auth.auth().currentUser?.uid {
            chatPartnerId = message?.fromId
        } else {
            chatPartnerId = message?.toId
        }
        
        if let id = chatPartnerId {
            let ref = Database.database().reference().child("users").child(id)
            ref.observe(.value) { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["name"] as? String
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //textLabel?.frame = CGRectMake(56, textLabel?.frame.origin.y, textLabel?.frame.origin.width, textLabel?.frame.origin.height  )
        if let textLabel = textLabel, let detailTextLabel = detailTextLabel {
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
    
    let timeLabel: UILabel = {
        let label = UILabel()
        //label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        addConstraintsToProfileImageView()
        
        addSubview(timeLabel)
        
        addConstraintsToTimeLabel()
        
    }
    
    func addConstraintsToTimeLabel() {
        // need x, y, width, height anchors
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
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
