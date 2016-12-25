//
//  Message.swift
//  Chat
//
//  Created by Tomoki Koga on 2016/12/25.
//  Copyright © 2016年 BizReach, inc. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let uid: String
    let name: String?
    let photo: URL?
    let text: String
    let at: Date
    
    var data: Any {
        var data = [String : Any]()
        
        data["uid"] = uid
        
        if let name = name {
            data["name"] = name
        }
        
        if let photo = photo?.absoluteString {
            data["photo"] = photo
        }
        
        data["text"] = text
        data["at"] = at.timeIntervalSince1970
        
        return data
    }
    
    init?(data: Any?) {
        guard let data = data as? [String : Any] else {
            return nil
        }
        
        self.uid = (data["uid"] as? String) ?? ""
        self.name = data["name"] as? String
        self.photo = (data["photo"] as? String).flatMap { URL(string: $0) }
        self.text = (data["text"] as? String) ?? ""
        self.at = (data["at"] as? TimeInterval).map { Date(timeIntervalSince1970: $0) } ?? Date()
    }
    
    init(text: String, at: Date = Date(), user: FIRUser? = FIRAuth.auth()?.currentUser) {
        self.uid = user?.uid ?? ""
        self.name = user?.displayName
        self.photo = user?.photoURL
        self.text = text
        self.at = at
    }
}
