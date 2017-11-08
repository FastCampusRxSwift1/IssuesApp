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

    var issue: Model.Issue!
    var headerSize: CGSize = CGSize.zero
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
        addKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNOtification()
    }
    
    override func viewDidLoad() {
        api = App.api.issueComment(owner: owner, repo: repo, number: issue.number)
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
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "IssueDetailHeaderView", for: indexPath) as? IssueDetailHeaderView ?? IssueDetailHeaderView()
            
            headerView.update(data: issue)
//            headerView.stateButton.addTarget(self, action: #selector(stateButtonTapped), for: .touchUpInside)
            return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadMoreFooterView", for: indexPath) as? LoadMoreFooterView ?? LoadMoreFooterView()
            
            loadMoreCell = footerView
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if headerSize == CGSize.zero {
            headerSize = IssueDetailHeaderView.headerSize(issue: issue, width: collectionView.frame.width)
            
        }
        return headerSize
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
        let comment = commentTextField.text ?? ""
        App.api.createComment(owner: owner, repo: repo, number: issue.number, comment: comment) { [weak self] (dataResponse: DataResponse<Model.Comment>) in
            guard let `self` = self else { return }
            switch dataResponse.result {
            case .success(let comment):
                self.addComment(comment: comment)
                self.commentTextField.text = ""
                self.commentTextField.resignFirstResponder()
                
                break
            case .failure:
                break
            }
        }
    }
}

extension IssueDetailViewController {
    
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, queue: nil) { [weak self] (notifiaction: Notification) in
            guard let `self` = self else { return }
            guard let keyboardBounds = notifiaction.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
            guard let animationDuration = notifiaction.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            guard let animationCurve = notifiaction.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UInt else { return }
            let animationOptions = UIViewAnimationOptions(rawValue: animationCurve)
            let keyboardHeight = keyboardBounds.height
            let inputBottom = self.view.frame.height - keyboardBounds.origin.y
            print("inputBottom: \(inputBottom)")
            print("keyboard: \(keyboardHeight)")
            var inset = self.collectionView.contentInset
            inset.bottom = inputBottom + 46
            self.collectionView.contentInset = inset
            self.inputViewBottomConstraint.constant = inputBottom
            UIView.animate(withDuration: animationDuration, delay: 0, options: animationOptions, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func removeKeyboardNOtification() {
        NotificationCenter.default.removeObserver(self)
    }
}

extension IssueDetailViewController {
    func addComment(comment: Model.Comment) {
        let newIndexPath = IndexPath(item: datasource.count, section: 0)
        datasource.append(comment)
        collectionView.insertItems(at: [newIndexPath])
        
        collectionView.scrollToItem(at: newIndexPath, at: .bottom, animated: true)
        
    }
}
