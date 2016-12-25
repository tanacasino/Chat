//
//  AuthViewController.swift
//  Chat
//
//  Created by Tomoki Koga on 2016/12/25.
//  Copyright © 2016年 BizReach, inc. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController, GIDSignInUIDelegate {

    var listenerHandle: FIRAuthStateDidChangeListenerHandle?
    
    deinit {
        // ログイン状態の監視をやめる
        if let listenerHandle = listenerHandle {
            FIRAuth.auth()?.removeStateDidChangeListener(listenerHandle)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // ログイン状態を監視する
        listenerHandle = FIRAuth.auth()?.addStateDidChangeListener({ [weak self] (auth, user) in
            if let _ = user {
                // ログイン状態（ログイン画面を閉じる）
                self?.dismiss(animated: true, completion: nil)
            } else {
                // 未ログイン状態
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
