//
//  LoginController+handlers.swift
//  ChartWithFIrebase1
//
//  Created by kyucraquispe on 3/5/20.
//  Copyright © 2020 kyucraquispe. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func handleRegister() {
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
            if error != nil {
                print(error!)
                return
            }
            
            //successfully authenticated user
            guard let uid = authResult?.user.uid else {
                print("uid is not present")
                return
            }
            
            let storageRef = Storage.storage().reference().child("profile_images").child(uid + ".png")
            
            
            
            if let updloadData = self.profileImageView.image?.jpegData(compressionQuality: 0.1) {
                storageRef.putData(updloadData, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        return
                    }
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    //image was successfully inserted on storage
                    print("image was successfully inserted on storage")
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url?.absoluteString else {
                            return
                        }
                        
                        let values = ["name": name, "email": email, "profileImageUrl": downloadURL] as [String : AnyObject]
                        
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                    }
                    
                    
                }
            }
            
            
        })
        print(123)
    }
    
    func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref =  Database.database().reference(fromURL: "https://ioschat-9261e.firebaseio.com")
        let userReference = ref.child("users").child(uid)
        
        userReference.updateChildValues(values) { Error, DatabaseReference in
            if Error != nil {
                print("Error trying to saved user info on database")
                print(Error!)
                return
            }
            
            print("Saved user successfully into Firebase db")
            self.dismiss(animated: true, completion: nil)
            print("Login Automatically when a user is inserted on the database")
        }
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //print(info)
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
}
