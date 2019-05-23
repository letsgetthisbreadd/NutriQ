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
    
  
    // MARK: - Properties
    var meals = [[String:Any]]()
    var targetCal = "2700"
    var diet = "high+protein"
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - CollectionView Arrays
    
    let mealImage = [UIImage(named: "food5"), UIImage(named: "food1"), UIImage(named: "food7")]

    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doRequestWithHeaders()
    
    }
    
    
    // MARK: - API Request
    func doRequestWithHeaders() {
     
        
        let MY_API_KEY = ""
        let Host = "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        
        let headers: HTTPHeaders = [
            "X-RapidAPI-Host": Host,
            "X-RapidAPI-Key": MY_API_KEY,
            "Accept": "application/json"
        ]
        
        // MARK: - To make sure the headers are sent, use debugPrint on the request
        let request = Alamofire.request("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/mealplans/generate?timeFrame=week&targetCalories=\(targetCal)&diet=\(diet)&exclude=shellfish%2C+olives", headers: headers)
            .responseJSON { response in
            //debugPrint(response)
                if let result = response.result.value {
                    let JSON = result as! [String : Any]
                    self.meals = JSON["items"] as! [[String : Any]]
                    print(self.meals)
                    self.collectionView.reloadData()
                    
                }
                
        }
        debugPrint(request)
    }

        

    // MARK: Cell Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FoodCell
        
        // Allows the variable needed to be the one for the correct number meal, based on the num of the selected cell
        let meal = meals[indexPath.row]
        
        // meal["day"] is based on the Int indexPath.row defined above
        let day = meal["day"] as! Int
        cell.dayNum.text = "\(day)"
        
        
        // This do statement unpacks the JSON string "value" and retrives the desired key:value pair
        // Refer to the API documentation to find what the "value" string is
        do {
            let dd =  meal["value"] as! String
            
            // Unpacks the JSON string, assigns it to an array of strings
            let con = try JSONSerialization.jsonObject(with: dd.data(using: .utf8)!, options: []) as! [String:Any]
            
            print("Printing meal: \(indexPath.row)")
            print(con["title"]!, "\n")
            
            // Finds the title of the selected meal and assigns it to the label mealName
            let title = con["title"] as! String
            cell.mealName.text = title
        }
        catch {
                print(error)
            }
        
        
        
        // This creates the shadows and modifies the cards a little bit
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
        
        // Allows the variable needed to be the one for the correct number meal, based on the num of the selected cell
        let meal = meals[indexPath.row]
        
        // This do statement unpacks the JSON string "value" and retrives the desired key:value pair
        do {
            let dd =  meal["value"] as! String
            let con = try JSONSerialization.jsonObject(with: dd.data(using: .utf8)!, options: []) as! [String:Any]
            
            // Finds the title of the selected meal and assigns it to mealTitle as a string
            let mealTitle = con["title"] as! String
            
            // That mealTitle string is then passed to MealDetailsViewController via this segue
            let detailsViewController = segue.destination as! MealDetailViewController
            detailsViewController.mealTitle = mealTitle
            
        }
        catch {
            print(error)
        }
        
        
    }
    

}
