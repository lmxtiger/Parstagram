//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Steven Liu on 11/13/20.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // Array of posts
    var posts = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fix UITableViewCell left margin
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: -13, bottom: 0, right: 0);
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Auto-refresh to fetch the new post the user just posted
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Posts")  // See back4app db
        query.includeKey("author")  // See back4app db
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                // Store the posts fetched from back4app database into the class field "posts"
                self.posts = posts!
                self.tableView.reloadData()
            }else{
                print("Posts Error: \(String(describing: error))")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username! + ": "
        cell.captionLabel.text = post["caption"] as? String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.photoView.af_setImage(withURL: url)
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
