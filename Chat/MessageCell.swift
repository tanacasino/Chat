//
//  MessageCellTableViewCell.swift
//  Chat
//
//  Created by 田中 智文 on 1/4/17.
//  Copyright © 2017 BizReach, inc. All rights reserved.
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
        task?.cancel()
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        task = session.dataTask(with: url){ [weak self] (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                self?.photoImageView.image = image
            }
        }
        
        task?.resume()
    }
}
