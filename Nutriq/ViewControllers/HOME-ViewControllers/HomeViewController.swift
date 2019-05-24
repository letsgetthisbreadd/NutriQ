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
import AlamofireImage


class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
  
    // MARK: - Properties
    var meals = [[String:Any]]()
    var mealData = [[String:Any]]()
    var targetCal = "2700"
    var diet = "high+protein"
    var count: Int = 0
    @IBOutlet weak var collectionView: UICollectionView!
    

    
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
                    
                    
    
                    self.mealDataRequest()
                }
        }
        debugPrint(request)
    }

    func mealDataRequest() {
        
        let MY_API_KEY = ""
        let Host = "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        var ID_LIST = [String]()
        var ID_String = ""
        
        
        do {
            for index in 0..<(meals.count) {
                let meal = meals[index]
                
                let mealValueJSONstring =  meal["value"] as! String
                let mealValueDictionary = try JSONSerialization.jsonObject(with: mealValueJSONstring.data(using: .utf8)!, options: []) as! [String:Any]
                let ID = mealValueDictionary["id"] as! Int
                
                ID_LIST.insert("\(ID)", at: index)
                ID_String = ID_LIST.joined(separator: "%2C")
                
                }
            print(ID_LIST)
            print(ID_String)
            }
        catch {
            print(error)
        }
        
        let headers: HTTPHeaders = [
            "X-RapidAPI-Host": Host,
            "X-RapidAPI-Key": MY_API_KEY,
            "Accept": "application/json"
        ]
        
        let requestURL = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/informationBulk?includeNutrition=true&ids=\(ID_String)"
        let request = Alamofire.request(requestURL, headers: headers)
            .responseJSON { response in
                //debugPrint(response)
                if let result = response.result.value {
                    self.mealData = result as! [[String : Any]]
                    print(self.mealData)
                    
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
        let mealDataHandler = mealData[indexPath.row]
        
        // meal["day"] is based on the Int indexPath.row defined above
        let day = meal["day"] as! Int
        cell.dayNum.text = "\(day)"
        cell.dayButton.layer.cornerRadius = 10
        
        if day == 2 {
            cell.dayButton.firstColor = .init(red: 255/255.0, green: 121/255.0, blue: 247/255.0, alpha: 1.0)
            cell.dayButton.secondColor = .init(red: 255/255.0, green: 61/255.0, blue: 221/255.0, alpha: 1.0)
        } else if day == 3 {
            cell.dayButton.firstColor = .init(red: 255/255.0, green: 92/255.0, blue: 74/255.0, alpha: 1.0)
            cell.dayButton.secondColor = .init(red: 255/255.0, green: 37/255.0, blue: 19/255.0, alpha: 1.0)
        } else if day == 4 {
            cell.dayButton.firstColor = .init(red: 29/255.0, green: 46/255.0, blue: 255/255.0, alpha: 1.0)
            cell.dayButton.secondColor = .init(red: 0/255.0, green: 19/255.0, blue: 193/255.0, alpha: 1.0)
        } else if day == 5 {
            cell.dayButton.firstColor = .init(red: 169/255.0, green: 255/255.0, blue: 103/255.0, alpha: 1.0)
            cell.dayButton.secondColor = .init(red: 124/255.0, green: 243/255.0, blue: 0/255.0, alpha: 1.0)
        } else if day == 6 {
            cell.dayButton.firstColor = .init(red: 13/255.0, green: 255/255.0, blue: 196/255.0, alpha: 1.0)
            cell.dayButton.secondColor = .init(red: 4/255.0, green: 206/255.0, blue: 176/255.0, alpha: 1.0)
        } else if day == 7 {
            cell.dayButton.firstColor = .init(red: 30/255.0, green: 193/255.0, blue: 80/255.0, alpha: 1.0)
            cell.dayButton.secondColor = .init(red: 0/255.0, green: 166/255.0, blue: 67/255.0, alpha: 1.0)
        } else if day == 1 {
            cell.dayButton.firstColor = .init(red: 95/255.0, green: 213/255.0, blue: 255/255.0, alpha: 1.0)
            cell.dayButton.secondColor = .init(red: 62/255.0, green: 166/255.0, blue: 231/255.0, alpha: 1.0)
        }
        
        let fallbackURL = "https://spoonacular.com/recipeImages/640190-556x370.jpg"
        let baseURL = mealDataHandler["image"] as? String ?? fallbackURL
        let posterURL = URL(string: baseURL)!
        cell.mealImage.af_setImage(withURL: posterURL)
        
        
        
        do {
            let mealValueJSONstring =  meal["value"] as! String
            
            // Unpacks the JSON string, assigns it to an array of strings
            let mealValueDictionary = try JSONSerialization.jsonObject(with: mealValueJSONstring.data(using: .utf8)!, options: []) as! [String:Any]
            
            print("Printing meal: \(indexPath.row)")
            print(mealValueDictionary["title"]!)
            print(mealValueDictionary["id"]!, "\n")
            
            // Finds the title of the selected meal and assigns it to the label mealName
            let title = mealValueDictionary["title"] as! String
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
            let mealValueJSONstring =  meal["value"] as! String
            let mealValueDictionary = try JSONSerialization.jsonObject(with: mealValueJSONstring.data(using: .utf8)!, options: []) as! [String:Any]
            
            // Finds the title of the selected meal and assigns it to mealTitle as a string
            let mealTitle = mealValueDictionary["title"] as! String
            
            // That mealTitle string is then passed to MealDetailsViewController via this segue
            let detailsViewController = segue.destination as! MealDetailViewController
            detailsViewController.mealTitle = mealTitle
            
        }
        catch {
            print(error)
        }
        
        
    }
    

}
