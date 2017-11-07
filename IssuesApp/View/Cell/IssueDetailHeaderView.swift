//
//  IssueDetailHeaderView.swift
//  GithubIssues
//
//  Created by Leonard on 2017. 9. 12..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit

@IBDesignable
class IssueDetailHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var commentContainerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var commentInfoLabel: UILabel!
    @IBOutlet weak var commentBodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        print("awakeFromNib")
    }
    
    public func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "IssueDetailHeaderView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView // swiftlint:disable:this force_cast
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }
    
    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
    
    fileprivate func setupNib() {
        let view = self.loadNib()
        
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:[], metrics:nil, views: bindings))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:[], metrics:nil, views: bindings))
    }
    
    static let estimateSizeCell: IssueDetailHeaderView = IssueDetailHeaderView()
}

// MARK: - setup
extension IssueDetailHeaderView {
    func setup() {
        stateButton.clipsToBounds = true
        stateButton.layer.cornerRadius = 2
        
        stateButton.setTitle(Model.Issue.State.open.rawValue, for: .normal)
        stateButton.setBackgroundImage(Model.Issue.State.open.color.toImage(), for: .normal)
        stateButton.setTitle(Model.Issue.State.closed.rawValue, for: .selected)
        stateButton.setBackgroundImage(Model.Issue.State.closed.color.toImage(), for: .selected)
        
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.midX
        
        commentContainerView.clipsToBounds = true
        commentContainerView.layer.cornerRadius = 2
        commentContainerView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        commentContainerView.layer.borderWidth = 1
        
    }
    static func headerSize(issue: Model.Issue, width: CGFloat) -> CGSize {
        
        IssueDetailHeaderView.estimateSizeCell.update(data: issue)
        let targetSize  = CGSize(width: width, height: 0)
        let size = IssueDetailHeaderView.estimateSizeCell.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: UILayoutPriorityRequired,
            verticalFittingPriority: UILayoutPriorityDefaultLow
        )
        let width = size.width == 0 ? IssueDetailHeaderView.estimateSizeCell.bounds.width : size.width
        let height = size.height == 0 ? IssueDetailHeaderView.estimateSizeCell.bounds.height : size.height
        let cellSize = CGSize(width: width, height: height)
        return cellSize
    }
}

extension IssueDetailHeaderView {
    func update(data: Model.Issue, withImage: Bool = true) {
        
        let createdAt = data.createdAt?.string(dateFormat: "dd MMM yyyy") ?? "-"
        titleLabel.text = data.title
        stateButton.isSelected = data.state == .closed
        infoLabel.text = "\(data.user.login) \(data.state.rawValue) this issue on \(createdAt) · \(data.comments) comments"
        
        //body
        if let url = data.user.avatarURL, withImage {
            avatarImageView.af_setImage(withURL: url)
        }
        commentInfoLabel.text = "\(data.user.login) commented on \(createdAt)"
        commentBodyLabel.text = data.body
    }
    
}
