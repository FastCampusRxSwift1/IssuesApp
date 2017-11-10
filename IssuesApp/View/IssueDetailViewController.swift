//
//  IssueDetailViewController.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 11. 8..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit
import Alamofire

class IssueDetailViewController: ListViewController<IssueCommentCell> {

    var issue: Model.Issue! {
        didSet {
            collectionView?.reloadData()
        }
    }
    var headerSize: CGSize = CGSize.zero
    var reloadIssue: ((Model.Issue) -> Void)?
    @IBOutlet override var collectionView: UICollectionView! {
        get {
            return collectionView_
        }
        set {
            collectionView_ = newValue
        }
    }
    @IBOutlet var collectionView_: UICollectionView!
    @IBOutlet var inputViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var commentTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "#\(issue.number)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func cellName() -> String  {
        return "IssueCommentCell"
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            assert(false, "unexpected element Kind")
            return UICollectionReusableView()
        case UICollectionElementKindSectionFooter:
            assert(false, "unexpected element Kind")
            return UICollectionReusableView()
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func sendButtonTapped(_ sender: Any) {
        send()
    }
    
    @objc func stateButtonTapped() {
        changeState()
    }
}

extension IssueDetailViewController {
    
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, queue: nil) { [weak self] (notifiaction: Notification) in
            }
    }
    
    func removeKeyboardNOtification() {
        NotificationCenter.default.removeObserver(self)
    }
}

extension IssueDetailViewController {
    func addComment(comment: Model.Comment) {

    }
    
    func send() {

    }
    
    func changeState() {
       
    }
}
