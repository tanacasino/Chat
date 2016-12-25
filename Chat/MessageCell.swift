//
//  MessageCell.swift
//  Chat
//
//  Created by Tomoki Koga on 2016/12/25.
//  Copyright © 2016年 BizReach, inc. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var task: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setMessage(message: Message) {
        nameLabel.text = message.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d hh:mm"
        dateLabel.text = formatter.string(from: message.at)
        
        messageLabel.text = message.text
        
        downloadPhoto(message: message)
    }
    
    private func downloadPhoto(message: Message) {
        guard let url = message.photo else {
            return
        }
        
        // 通信中だったらキャンセルする（セルが使い回されるので。。）
        task?.cancel()
        
        // 写真データをダウンロードする
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                self?.photoImageView.image = image
            }
        }
        
        // 通信開始
        task?.resume()
    }
}



