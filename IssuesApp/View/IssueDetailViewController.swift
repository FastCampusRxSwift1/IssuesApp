//
//  IssueDetailViewController.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 11. 8..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        api = App.api.issueComment(owner: owner, repo: repo, number: issue.number)
        super.viewDidLoad()
        
        
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

}
