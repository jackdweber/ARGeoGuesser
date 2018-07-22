//
//  MultiPlayTableViewController.swift
//  Examples
//
//  Created by Jack Weber on 7/21/18.
//  Copyright © 2018 MapBox. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MultiPlayTableViewController: UITableViewController, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var items: (MCSession, String, (Double, Double, Double, Double))!
    var peers: [MCPeerID] = []
    let browser = MCNearbyServiceBrowser(peer: MCPeerID(displayName: UIDevice.current.name), serviceType: "ARGG")
    let advertiser = MCNearbyServiceAdvertiser(peer: MCPeerID(displayName: UIDevice.current.name), discoveryInfo: nil, serviceType: "ARGG")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        browser.delegate = self
        advertiser.delegate = self
        
        let alert = UIAlertController(title: "Select", message: "Would you like to join or host?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { (_) in
            print("Join")
            self.browser.startBrowsingForPeers()
        }))
        alert.addAction(UIAlertAction(title: "Host", style: .default, handler: { (_) in
            print("Host")
            self.advertiser.startAdvertisingPeer()
        }))
        present(alert, animated: true, completion: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        peers.append(peerID)
        tableView.reloadData()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        if let index = peers.firstIndex(of: peerID) {
            peers.remove(at: index)
            tableView.reloadData()
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("recied")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeerCell", for: indexPath)

        cell.textLabel?.text = peers[indexPath.row].displayName

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        browser.invitePeer(peers[indexPath.row], to: items.0, withContext: nil, timeout: 15)
    }

}
