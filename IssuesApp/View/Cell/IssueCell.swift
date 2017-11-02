//
//  IssueCell.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 11. 1..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit

protocol CellProtocol {
    associatedtype Item
    func update(data: Item)
    static var cellFromNib: Self { get }
}


final class IssueCell: UICollectionViewCell {
    @IBOutlet var stateButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var commentCountButton: UIButton!
}

extension IssueCell: CellProtocol {
    typealias Item = Model.Issue
    
    static var cellFromNib: IssueCell {
        guard let cell = Bundle.main.loadNibNamed("IssueCell", owner: nil, options: nil)?.first as? IssueCell else {
            return IssueCell()
        }
        return cell
    }
    
    func update(data issue: Model.Issue) {
        titleLabel.text = issue.title
        contentLabel.text = issue.body
        let createdAt = issue.createdAt?.string(dateFormat: "dd MMM yyyy") ?? "-"
        contentLabel.text = "#\(issue.number) \(issue.state.rawValue) on \(createdAt) by \(issue.user.login)"
        commentCountButton.setTitle("\(issue.comments)", for: .normal)
        stateButton.isSelected = issue.state == .closed
        let commentCountHidden: Bool = issue.comments == 0
        commentCountButton.alpha = commentCountHidden ? 0 : 1
    }
}

extension Date {
    func string(dateFormat: String, locale: String = "en-US") -> String {
        let format = DateFormatter()
        format.dateFormat = dateFormat
        format.locale = Locale(identifier: locale)
        return format.string(from: self)
    }
}

