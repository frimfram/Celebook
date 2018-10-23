//
//  LoginViewController.swift
//  Celebook
//
//  Created by Jean Ro on 4/2/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPasswordTextField.isSecureTextEntry = true
    }
    
    @IBAction func onLoginButtonClicked(_ sender: UIButton) {
        guard let email = loginEmailTextField.text else {
            showLoginError("Please enter email")
            return
        }
        guard let password = loginPasswordTextField.text else {
            showLoginError("Please enter password")
            return
        }
        signIn(email: email, password: password)
    }
    
    @IBAction func onSignUpButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Register",
                                      message: "Sign up for a new account",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            guard let email = alert.textFields![0].text else {
                return
            }
            guard let password = alert.textFields![1].text else {
                alert.message = "Please enter password"
                return
            }

            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                guard error == nil else {
                    alert.message = "Error creating a new user.  Please try it later."
                    return
                }
                self.signIn(email: email, password: password)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name.UITextFieldTextDidChange,
                object: textEmail,
                queue: OperationQueue.main) { [weak self] (notification) in
                guard let strongSelf = self else { return }
                guard let emailStr = textEmail.text else {
                    saveAction.isEnabled = false
                    return
                }
                saveAction.isEnabled = strongSelf.isValid(email: emailStr)
            }
        }
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func isValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let strongSelf = self else { return }
            guard error == nil else {
                strongSelf.showLoginError("Error encountered while logging in...")
                return
            }
            //start initial view controller
            strongSelf.showInitialView()
        }
    }
    
    func showInitialView() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let initialVC = storyBoard.instantiateViewController(withIdentifier: "InitialViewController")
        initialVC.modalPresentationStyle = .fullScreen
        present(initialVC, animated: false, completion: nil)
    }
    
    func showLoginError(_ message: String) {
        let alertController = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
