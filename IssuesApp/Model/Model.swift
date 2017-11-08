//
//  Model.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 10. 27..
//  Copyright © 2017년 intmain. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Model {
    
}

extension Model {
    struct Issue {
        let id: Int
        let number: Int
        let title: String
        let user: Model.User
        let state: State
        let comments: Int
        let body: String
        let createdAt: Date?
        let updatedAt: Date?
        let closedAt: Date?
        
        init(json: JSON) {
            print("issue json: \(json)")
            id = json["id"].intValue
            number = json["number"].intValue
            title = json["title"].stringValue
            user = Model.User(json: json["user"])
            state = State(rawValue: json["state"].stringValue) ?? .open
            comments = json["comments"].intValue
            body = json["body"].stringValue
            
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            createdAt = format.date(from: json["created_at"].stringValue)
            updatedAt = format.date(from: json["updated_at"].stringValue)
            closedAt = format.date(from: json["closed_at"].stringValue)
        }
    }
}

extension Model.Issue {
    enum State: String {
        case open
        case closed
    }
}

extension Model.Issue.State {
    var color: UIColor {
        switch  self {
        case .open:
            return UIColor(red: 131/255, green: 189/255, blue: 71/255, alpha: 1)
        case .closed:
            return UIColor(red: 176/255, green: 65/255, blue: 32/255, alpha: 1)
        }
    }
}

extension Model.Issue {
    var toDict: [String: Any] {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        var dict: [String : Any] = [
            "id": id,
            "number": number,
            "title": title,
            "comments": comments,
            "body": body,
            "state": state.rawValue,
            "user": [
                "id": user.id,
                "login": user.login,
                "acatar_url": (user.avatarURL?.absoluteString ?? "")]
        ]
        if let createdAt = createdAt {
            dict["createdAt"] = format.string(from: createdAt)
        }
        if let updatedAt = updatedAt {
            dict["updatedAt"] = format.string(from: updatedAt)
        }
        if let closedAt = closedAt {
            dict["closedAt"] = format.string(from: closedAt)
        }
        
        print("dict: \(dict)")
        return dict
        
    }
}

extension Model.Issue: Equatable {
    static func ==(lhs: Model.Issue, rhs: Model.Issue) -> Bool {
        return lhs.id == rhs.id
    }
}

extension UIColor {
    func toImage(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(self.cgColor)
            context.fill(rect)
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return image
            }
        }
        return UIImage()
    }
}

extension Model {
    struct User {
        let id: String
        let login: String
        let avatarURL: URL?
        
        init(json: JSON) {
            id = json["id"].stringValue
            login = json["login"].stringValue
            avatarURL = URL(string: json["avatar_url"].stringValue)
        }
    }
}

extension Model {
    public struct Comment {
        let id: Int
        let user: Model.User
        let body: String
        let createdAt: Date?
        let updatedAt: Date?
        public init(json: JSON) {
            id = json["id"].intValue
            user = Model.User(json: json["user"])
            body = json["body"].stringValue
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            createdAt = format.date(from: json["created_at"].stringValue)
            updatedAt = format.date(from: json["updated_at"].stringValue)
        }
    }
}
