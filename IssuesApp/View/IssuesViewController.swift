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
        if let indexPath = self.collectionView.indexPathsForSelectedItems?.first,
            let viewConroller = segue.destination as? IssueDetailViewController {
            let issue = datasource[indexPath.item]
            viewConroller.issue = issue
            viewConroller.reloadIssue = { [weak self] (issue: Model.Issue) in
                guard let `self` = self else { return }
                guard let index = self.datasource.index(of: issue) else { return }
                self.datasource[index] = issue
                let indexPath = IndexPath(item: index, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
            }
        } else if let navigationController = segue.destination as? UINavigationController, 
            let createIssueViewController = navigationController.topViewController as? CreateIssueViewController {
            createIssueViewController.repo = repo
            createIssueViewController.owner = owner
        }
    }
 
    
    override func cellName() -> String  {
        return "IssueCell"
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowIssueDetailSegue", sender: nil)
    }
    
    @IBAction func unwindFromCreate(_ segue: UIStoryboardSegue) {
        if let createViewController = segue.source as? CreateIssueViewController, let createdIssue = createViewController.createdIssue {
            datasource.insert(createdIssue, at: 0)
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
            
        }
    }

}



