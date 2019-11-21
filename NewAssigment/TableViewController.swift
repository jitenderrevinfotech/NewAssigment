//
//  TableViewController.swift
//  NewAssigment
//
//  Created by akash.jaiswal on 21/11/19.
//  Copyright © 2019 Assigment.int. All rights reserved.
//

import UIKit
import Alamofire

class TableViewController: UITableViewController {
//Local veriable
    fileprivate var pageNumber = 0
    fileprivate var arrData = [ListData]()
    fileprivate var noMoreResults = false
}

//MARK: - View hirarchy
extension TableViewController{
    
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do additional setup
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            //Web service call
            self.noMoreResults = false
            self.callWebserviceForFetchData(pageNumber: pageNumber)
        }
        
        override func viewDidLayoutSubviews() {
            //Update dislying cell count at the time of visiblity update
            //display the number of the total displaying posts
            self.navigationItem.title = "Display data:\(self.tableView.visibleCells.count)"
        }

}

extension TableViewController{
    
    //MARK: - UItableview delegates and data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...

        let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as! DataTableViewCell
        let listData = self.arrData[indexPath.row]
        //Displaying the data
        cell.showData(data:listData)
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.arrData.count - 4{
            if !noMoreResults{
                
                //Update page number
                pageNumber = pageNumber + 1
                
                //Auto load more content
                //Call API for next page
                
                self.callWebserviceForFetchData(pageNumber: pageNumber)
            }
        }
    }
    
}

//MARK: - Webservice calling

fileprivate extension TableViewController{
    
    //Only call when No more results is false we use this because if any time hits response 0 data our pagination will stopped at that time
    
    func callWebserviceForFetchData(pageNumber:Int){
        
        //Remove all elements from arry if page number is 0
        if pageNumber == 0 {
            self.arrData.removeAll()
        }
        //URL
        let URI = "https://hn.algolia.com/api/v1/search_by_date?tags=story"
        
        //Paginaiton Parameter
        let dicParam = ["page":"\(pageNumber)"]
        
        // API Request::
        
        Alamofire.request(URI, method: .get, parameters: dicParam, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result{
            case .success:
                do{
                    // Decode Response data to json object
                    if let dict = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]{
                        if let arr = dict["hits"] as? [[String:Any]]{
                            if arr.count > 0{
                                for item in arr {
                                    let listdata = ListData.init(title: item["title"] as! String, Created: item["created_at"] as! String)
                                    self.arrData.append(listdata)
                                }
                                self.tableView.reloadData()
                            }else{
                                self.noMoreResults = true
                                self.ShowAlert(title: "Alert", Message: "No results found")
                            }
                        }
                    }
                }catch{
                    //Handle Error
                    print(error.localizedDescription)
                    self.ShowAlert(title: "Error", Message: error.localizedDescription)
                }
                
            case .failure:
                // Display error in case of failure
                self.ShowAlert(title: "Error", Message: response.error?.localizedDescription ?? "Something went wrong")
            }
            
        }
    }
    
    //ALERT
    func ShowAlert(title:String,Message:String){
        //Create alert controller
        let alert = UIAlertController.init(title: title, message: Message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
