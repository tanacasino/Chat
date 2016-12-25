//
//  ViewController.swift
//  Chat
//
//  Created by Tomoki Koga on 2016/12/25.
//  Copyright © 2016年 BizReach, inc. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 72
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // ログイン状態をチェック
        if let _ = FIRAuth.auth()?.currentUser {
            // ログイン状態の場合は、メッセージの一覧を取得して表示する
            observeMessages()
        } else {
            // 未ログイン状態の場合は、ログイン画面を表示
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
            
            // モーダルでログイン画面を開く
            present(viewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unobserveMessages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addMessage(message: Message) {
        messages.append(message)
        
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .bottom)
    }
    
    private func observeMessages() {
        let ref = FIRDatabase.database().reference(withPath: "messages")
        ref.observe(.childAdded, with: { [weak self] (snapshot) in
            if let message = Message(data: snapshot.value) {
                self?.addMessage(message: message)
            }
        })
    }
    
    private func unobserveMessages() {
        FIRDatabase.database().reference(withPath: "messages").removeAllObservers()
    }
    
    @IBAction func onTapBySend(_ sender: Any) {
        guard let text = textField.text else {
            return
        }
        
        let ref = FIRDatabase.database().reference(withPath: "messages").childByAutoId()
        ref.setValue(Message(text: text).data)
        
        textField.text = nil
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessageCell
        cell.setMessage(message: messages[indexPath.row])
        return cell
    }
}
