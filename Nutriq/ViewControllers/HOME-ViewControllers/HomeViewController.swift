//
//  HomeViewController.swift
//  Nutriq
//
//  Created by Albert Gertskis on 4/24/19.
//  Copyright © 2019 NutriQ. All rights reserved.
//

import UIKit
import Firebase
import Alamofire


class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var meals = [[String: Any]]()
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - CollectionView Arrays
    
    let mealName = ["Manwich", "Chicken Tortilla", "Steak and Mashed Potatoes"]
    let mealImage = [UIImage(named: "food5"), UIImage(named: "food1"), UIImage(named: "food7")]
    let mealDescription = ["A nice sandwich", "Spicy mami", "Bland but gud"]
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doRequestWithHeaders1()
    
        
    }
    
    func doRequestWithHeaders1() {
        let MY_API_KEY = "472b7cc975msh060aefd68adf082p1bb2bejsn5903ef69b2cd"
        let Host = "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        
        let headers: HTTPHeaders = [
            "X-RapidAPI-Host": Host,
            "X-RapidAPI-Key": MY_API_KEY,
            "Accept": "application/json"
        ]
        
        // MARK: - To make sure the headers are sent, use debugPrint on the request
        let request = Alamofire.request("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/mealplans/generate?targetCalories=2700&timeFrame=day", headers: headers)
            .responseJSON { response in
            //debugPrint(response)
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    self.meals = JSON
                    
                }
                
                
        }
        debugPrint(request)
    }

        

    // MARK: Cell Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mealName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FoodCell
        
        cell.mealName.text = mealName[indexPath.row]
        cell.mealImage.image = mealImage[indexPath.row]
        cell.mealDescription.text = mealDescription[indexPath.row]
        
        
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Passing data to MealDetails VC...")
        
        // Find the selected meal name
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let mealTitle = mealName[indexPath.row]
        
        let detailsViewController = segue.destination as! MealDetailViewController
        detailsViewController.mealTitle = mealTitle
    }
    

}
