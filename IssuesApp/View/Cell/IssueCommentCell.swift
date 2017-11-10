//
//  IssueCommentCell.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 11. 7..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit
import AlamofireImage

final class IssueCommentCell: UICollectionViewCell, CellProtocol {
    
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var commentContanerView: UIView!
    
    override func awakeFromNib() {

    }
    
}

extension IssueCommentCell {
    typealias Item = Model.Comment
    
    func update(data: Model.Comment) {
        
    }

    static var cellFromNib: IssueCommentCell {
        return IssueCommentCell()
    }
}

