//
//  LocalNetworkCoordinator.swift
//  Freed Leaderboard
//
//  Created by Sumit Pradhan on 6/17/24.
//  URL: https://medium.com/@input.split/step-by-step-guide-to-multipeer-connectivity-c66f6a688cd6
//  Edited by Isaac D2 on 1/2/26.
//
 
import Foundation
import MultipeerConnectivity
 
 @Observable
 class LocalNetworkSessionCoordinator: NSObject {
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    private let session: MCSession
    
    private(set) var allDevices: Set<MCPeerID> = []
    private(set) var connectedDevices: Set<MCPeerID> = []
    var otherDevices: Set<MCPeerID> {
        return allDevices.subtracting(connectedDevices)
    }
    private(set) var message: String = ""
    private(set) var leaderboardData: Data = Data()
    
    
    init(peerID: MCPeerID = .init(displayName: UIDevice.current.name)) {
        advertiser = .init(
            peer: peerID,
            discoveryInfo: nil,
            serviceType: .messageSendingService
        )
        browser = .init(
            peer: peerID,
            serviceType: .messageSendingService
        )
        session = .init(peer: peerID)
        super.init()
        
        browser.delegate = self
        advertiser.delegate = self
        session.delegate = self
    }
    
    public func startAdvertising() {
        advertiser.startAdvertisingPeer()
    }
    
    public func stopAdvertising() {
        advertiser.stopAdvertisingPeer()
    }
    
    public func startBrowsing() {
        browser.startBrowsingForPeers()
    }
    
    public func stopBrowsing() {
        browser.stopBrowsingForPeers()
    }
    
    public func invitePeer(peerID: MCPeerID) {
        browser.invitePeer(
            peerID,
            to: session,
            withContext: nil,
            timeout: 120
        )
    }
    
     public func sendHello(peerID: MCPeerID, message: String = "Hello, World.") throws {
         let formattedMessage = message.data(using: .utf8)
         try session.send(
            formattedMessage!,
            toPeers: [peerID],
            // .reliable = TCP
            // .unreliable = UDP
            // Remember that we have added two set of configuration on the Info.plist
            // file at the time of configuration. We want guranteed message delivery
            // so we choose TCP/.reliable.
            with: .reliable
        )
    }
}
                                                                             
extension LocalNetworkSessionCoordinator: MCNearbyServiceAdvertiserDelegate {
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        invitationHandler(true, session)
    }
}
                                                                             
extension LocalNetworkSessionCoordinator: MCNearbyServiceBrowserDelegate {
    func browser(
        _ browser: MCNearbyServiceBrowser,
        foundPeer peerID: MCPeerID,
        withDiscoveryInfo info: [String : String]?
    ) {
        allDevices.insert(peerID)
    }
    
    func browser(
        _ browser: MCNearbyServiceBrowser,
        lostPeer peerID: MCPeerID
    ) {
        allDevices.remove(peerID)
    }
    
}
                                                                             
extension LocalNetworkSessionCoordinator: MCSessionDelegate {
    func session(
        _ session: MCSession,
        peer peerID: MCPeerID,
        didChange state: MCSessionState
    ) {
        print("The first session function was called")
        if state == .connected {
            connectedDevices.insert(peerID)
        } else {
            connectedDevices.remove(peerID)
        }
    }
    
    func session(
        _ session: MCSession,
        didReceive data: Data,
        fromPeer peerID: MCPeerID,
    ) {
        print("The second session function was called")
        leaderboardData = data
        print("LEADERBOARD DATA FROM LOCALNETWORKCOORDINATOR")
        print(String(data: leaderboardData, encoding: .utf8)!)
        print("END OF LOCALNETWORKCOORDINATOR PRINT")
    }
    
    func session(
        _ session: MCSession,
        didReceive stream: InputStream,
        withName streamName: String,
        fromPeer peerID: MCPeerID
    ) {
        print("The third session function was called")
    }
    
    func session(
        _ session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        with progress: Progress
    ) {
        print("The fourth session function was called")
    }
    
    func session(
        _ session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        at localURL: URL?,
        withError error: (any Error)?
    ) {
        print("The fifth session function was called")
    }
}
                                                                             
private extension String {
    static let messageSendingService = "sendMessage"
}
