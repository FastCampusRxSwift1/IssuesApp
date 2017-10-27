//
//  LoginViewController.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 10. 27..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit
import OAuthSwift

class LoginViewController: UIViewController {
    let oauth: OAuth2Swift =  OAuth2Swift(consumerKey: "dc7db1de744aa3e82a47",
                                          consumerSecret: "554a3e9b89f140736050a37e3e37379aa3bc7e39",
                                          authorizeUrl: "https://github.com/login/oauth/authorize",
                                          accessTokenUrl: "https://github.com/login/oauth/access_token",
                                          responseType: "code")
    override func viewDidLoad() {
        super.viewDidLoad()

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


extension LoginViewController {
    @IBAction func loginToGitHubButtonTapped() {
       oauth.authorize(withCallbackURL: "IssuesApp://oauth-callback/github",
                       scope: "user, repo",
                       state: "state",
                       success: { (credentail, _, _) in
                        let token = credentail.oauthToken
                        let refreshToken = credentail.oauthRefreshToken
                        print("token: \(token), refreshToken: \(refreshToken)")
                   },
                       failure:  { error in
                        print(error.localizedDescription)
                   })
    }
}
