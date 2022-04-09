//
//  FeedViewController.swift
//  Parsely
//
//  Created by Gyandeep Reddy on 4/8/22.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var tableView: UITableView!
    var Recipes = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "Recipes")
        query.includeKeys(["name", "cook_time", "prep_time", "tags"])
        query.limit = 20
        query.findObjectsInBackground(){ (Recipes, error) in
            if Recipes != nil {
                self.Recipes = Recipes!
                self.tableView.reloadData()
                
            }
            
        }
    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Recipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeCell
        let recipe = Recipes[indexPath.row]
        let nameRecipe = recipe["name"] as! String
        cell.recipeName.text = nameRecipe
        let prepTime = recipe["prep_time"] as! String
        cell.prepTimeLabel.text = prepTime
        let cookTime = recipe["cook_time"] as! String
        cell.cookTimeLabel.text = cookTime
        let imageFile = recipe["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.recipePhotoView.af.setImage(withURL: url)
        
        return cell
    }
 
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate
        else {return}
        delegate.window?.rootViewController = loginViewController
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
