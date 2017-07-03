//
//  CubeGuideTableViewController.swift
//  ARSRP
//
//  Created by Avikant Saini on 7/3/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

import UIKit

class CubeGuideTableViewController: UITableViewController {
	
	var srps = Array<SRPItem>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		self.srps = SRPManager.sharedManager.items;
		
    }
	
	
	@IBAction func doneAction(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return srps.count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "srpCell", for: indexPath)

        // Configure the cell...
		
		let item = self.srps[indexPath.row]
		
		cell.imageView?.image = UIImage(named: "\(item.imageName)")
		cell.textLabel?.text = item.title
		cell.detailTextLabel?.text = "+\(item.score)"

        return cell
    }

	// MARK: - Table view delegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "imageSegue" {
			if let cell = sender as? UITableViewCell {
				if let indexPath = tableView.indexPath(for: cell) {
					let item = self.srps[indexPath.row]
					let dest = segue.destination as! SRPImageViewController
					dest.imageName = item.imageName
				}
			}
		}
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
