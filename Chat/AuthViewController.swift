//
//  AuthViewController.swift
//  Chat
//
//  Created by 田中 智文 on 1/4/17.
//  Copyright © 2017 BizReach, inc. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController, GIDSignInUIDelegate {

    var listenerHandle: FIRAuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
        
        listenerHandle = FIRAuth.auth()?.addStateDidChangeListener({ [weak self] (auth, user) in
            if let _ = user {
                self?.dismiss(animated: true, completion: nil)
            } else {
                
            }
        })
        
    }

    deinit {
        if let listenerHandle = listenerHandle {
            FIRAuth.auth()?.removeStateDidChangeListener(listenerHandle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
