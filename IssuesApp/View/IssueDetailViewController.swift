//
//  IssueDetailViewController.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 11. 8..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit

class IssueDetailViewController: ListViewController<IssueCommentCell> {

    @IBOutlet override var collectionView: UICollectionView! {
        get {
            return collectionView_
        }
        set {
            collectionView_ = newValue
        }
    }
    @IBOutlet var collectionView_: UICollectionView!
    
    var issue: Model.Issue!
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
