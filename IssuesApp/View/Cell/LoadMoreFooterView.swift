//
//  LoadMoreFooterView.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 11. 2..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit

@IBDesignable
class LoadMoreFooterView: UICollectionReusableView {
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var doneView: UIView!
    
    public func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LoadMoreFooterView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else { return UIView() }
        return view
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

}

extension LoadMoreFooterView {
    func loadDone() {
        activityIndicatorView.isHidden = true
        doneView.isHidden = false
    }
    
    func load() {
        activityIndicatorView.isHidden = false
        doneView.isHidden = true
    }
}
