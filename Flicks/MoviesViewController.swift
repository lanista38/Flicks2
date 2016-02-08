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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet var swipeCategory: UISwipeGestureRecognizer!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    var searchBarController: UISearchController!
    var filteredData: [NSDictionary]?
    var movies: [NSDictionary]?
    let refreshControl = UIRefreshControl()
    var bool = true
    var endPoint: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let refreshControl = UIRefreshControl()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .SingleLine
        tableView.separatorColor = UIColor.blackColor()
        
        
        searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.searchResultsUpdater = self
        searchBarController.searchBar.sizeToFit()
        navigationItem.titleView = searchBarController.searchBar
        searchBarController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
    
        
        networkRequest();
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
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
        if let filteredData = self.filteredData{
            return filteredData.count
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell",forIndexPath: indexPath) as! MovieCell
        
         let movie = filteredData![indexPath.row]
         let title = movie["title"] as! String
       // let overview = movie["overview"] as! String
        let rating = movie["vote_average"] as! Int
        let releaseDate = movie["release_date"]as! String
        
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
             let urlRequest = NSURLRequest(URL: posterUrl!)
            cell.posterView.setImageWithURLRequest(urlRequest, placeholderImage: nil,
                success: {
                    (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) -> Void in
                    if response != nil {
                        cell.posterView.alpha = 0
                        cell.posterView.image = image
                        UIView.animateWithDuration(0.3, animations: {cell.posterView.alpha = 1})
                    }
                    else {
                        cell.posterView.image = image
                    }
                },
                failure: {
                    (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) -> Void in })
        }
        
        
        cell.titleLabel.text = title
        //cell.overviewLabel.text = overview
        cell.ratingLabel.text = String(rating) + "/10"
        cell.releaseDateLabel.text = releaseDate
        let backgroundView = UIView()
        
      
        backgroundView.backgroundColor = UIColor.orangeColor()
        cell.selectedBackgroundView = backgroundView

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
                
    }

    
    func updateSearchResultsForSearchController(searchController: UISearchController){
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty {
                self.filteredData = self.movies
            }
            else {
                self.filteredData = movies!.filter({ (movie: NSDictionary) -> Bool in
                    if let title = movie["title"] as? String {
                        
                        if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                            return  true
                        }
                           
                        else{
                            return false
                        }
                    }
                    return false
                })
            }
              self.tableView.reloadData()
        }
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
       
        networkRequest()
        
        
        refreshControl.endRefreshing()
    }
    func networkRequest(){
        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
        
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
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredData = self.movies
                            self.tableView.reloadData()
                    }
                }
                self.tableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                self.refreshControl.endRefreshing()
        });
        task.resume()
    }
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Right) {
            bool = true
            
        }
        if(sender.direction == .Left)
        {
            bool = false
            
        }
         self.tableView.reloadData()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let theCell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(theCell)
        let theMovie = filteredData![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = theMovie
        
    }
    
  
   }

