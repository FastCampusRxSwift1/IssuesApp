//
//  IssuesViewController.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 10. 28..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit
import Alamofire

class IssuesViewController: UIViewController {

    let owner = GlobalState.instance.owner
    let repo = GlobalState.instance.repo
    var datasource: [Model.Issue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension IssuesViewController {
    func setup() {
        load()
    }
    
    func load() {
        App.api.repoIssues(owner: owner, repo: repo, page: 1, handler: { (response: DataResponse<[Model.Issue]>) in
            switch response.result {
            case .success(let items):
                print("issues: \(items)")
            case .failure:
                break
            }
        })
    }
    
    func dataLoaded(items: [Model.Issue]) {
        
    }
}
