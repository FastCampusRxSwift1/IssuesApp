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
    }
    static func headerSize(issue: Model.Issue, width: CGFloat) -> CGSize {
        return CGSize.zero
    }
}

extension IssueDetailHeaderView {
    func update(data: Model.Issue) {

    }
    
}
