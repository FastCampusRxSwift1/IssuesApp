//
//  IssuesViewController.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 11. 2..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit

class IssuesViewController: ListViewController<IssueCell> {

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
        api = App.api.repoIssues(owner: owner, repo: repo)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = self.collectionView.indexPathsForSelectedItems?.first else { return }
        guard let viewConroller = segue.destination as? IssueDetailViewController else { return }
        let issue = datasource[indexPath.item]
        viewConroller.issue = issue
    }
 
    
    override func cellName() -> String  {
        return "IssueCell"
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowIssueDetailSegue", sender: nil)
    }
}



