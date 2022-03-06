//
//  ViewController.swift
//  Flix
//
//  Created by Jasmine Lee on 2/27/22.
//
import UIKit
import AlamofireImage

//1. add UITableViewDataSource, UITableViewDelegate
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //properties available for the entirety of the screen
    //creation of array of dictionaries
    var movies = [[String:Any]]()

    //2. add table view outlet
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //3. add these lines
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        print("Hello")
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                 //get key from dictionary of movies and use casting
                 self.movies = dataDictionary["results"] as! [[String:Any]]
                 
                 //5. download is complete now so elements are received properly in functions below
                 self.tableView.reloadData()
                 
                 print(dataDictionary)
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data
             }
        }
        task.resume()
    }
    
    //4. add fxns
    //number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    //for particular row, give it a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeueReusableCell recycles cells off screen
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        //? is for swift optionals
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        //gets url from api
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        //terminal: pod init, open Podfile (type in alamofireimage), pod install (to get alamofire library to get images), open .
        //from using pods to set image of poster
        cell.posterView.af_setImage(withURL: posterUrl!)
        return cell
    }


}
