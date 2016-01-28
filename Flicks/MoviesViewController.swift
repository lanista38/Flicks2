//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Jorge Cruz on 1/26/16.
//  Copyright © 2016 Jorge Cruz. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet var swipeCategory: UISwipeGestureRecognizer!
    @IBOutlet weak var categorySegmenter: UISegmentedControl!
    
    @IBOutlet weak var moviesSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    var filteredMovies: [String]!
    var movies: [NSDictionary]?
    let refreshControl = UIRefreshControl()
    var bool = true
    
   
    @IBAction func categoriesValueChanged(sender: AnyObject) {
        
        
        if(categorySegmenter.selectedSegmentIndex == 0)
        {
            bool = true;
        }
        else
        {
            bool = false
        }
        networkRequest(refreshControl);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //let refreshControl = UIRefreshControl()
        
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        
        moviesSearchBar.delegate = self
       // filteredMovies = movie["title"] as! String
        
        
        
        networkRequest(refreshControl);
        refreshControl.addTarget(self, action: "networkRequest:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        self.tableView.tableHeaderView = nil;
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if let movies = movies{
            return movies.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell",forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        
        let overview = movie["overview"] as! String
        
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            cell.posterView.setImageWithURL(posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            cell.posterView.image = nil
        }
        
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
      
        
        
        return cell
    }
    
    func networkRequest(refreshControl: UIRefreshControl){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        var url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        if(bool)
        {
         url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        } else if(!bool)
        {
             url = NSURL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)")
        }
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.tableView.reloadData()
                    }
                }
                self.tableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()
        });
        task.resume()
    }
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Right) {
            bool = true
            categorySegmenter.selectedSegmentIndex = 0
        }
        if(sender.direction == .Left)
        {
            bool = false
            categorySegmenter.selectedSegmentIndex = 1
        }
         networkRequest(refreshControl);
    }
    
    
}

