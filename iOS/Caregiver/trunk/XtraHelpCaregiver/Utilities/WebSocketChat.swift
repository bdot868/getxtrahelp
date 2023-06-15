//
//  WebSocketChat.swift
//  iTemp
//
//  Created by Wdev3 on 19/11/20.
//  Copyright © 2020 APPLE. All rights reserved.
//

import UIKit
import UIKit

protocol webSocketChatDelegate {
    func SendReceiveData(dict : [String:AnyObject])
}

class WebSocketChat: NSObject {

    static let shared = WebSocketChat()
    
    var Socket: WebSocket?
    var isSocketConnected = false
    var delegate : webSocketChatDelegate?
    
    func connectSocket() {
        if isSocketConnected == false {
            if let socketurl = URL(string: AppConstant.WebSocketAPI.socketURL) {
                var request = URLRequest(url: socketurl)
                request.timeoutInterval = 60
                
                Socket = WebSocket.init(request:request, certPinner: FoundationSecurity(allowSelfSigned: true), compressionHandler: nil)
                Socket?.delegate = self
                
                Socket?.connect()
            } else {
                print("Failed to connect")
            }
        } else {
            Socket?.delegate = self
        }
    }
    
    func disconnectSocket(){
        Socket?.disconnect()
    }
    
    func pingSocket() {
        self.Socket?.write(ping: Data()) {
            //print("Web Socket connection is alive")
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                self.pingSocket()
            }
        }
    }
    
    func pongSocket() {
        self.Socket?.write(pong: Data())
    }
    
    func writeSocketData(dict : [String:Any]){
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dict,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .utf8)
            
            if let jstring = theJSONText {
                print("JSON string = \(jstring)")
                self.Socket?.write(string: "\(jstring)")
            }
        }
    }
}

extension WebSocketChat : WebSocketDelegate{
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("websocket is connected: \(headers)")
            print("Connection Done")
            delay(seconds: 0.1) {
                NotificationCenter.default.post(name: Notification.Name(NotificationPostname.kReloadChatConnected), object: nil, userInfo: nil)
            }
            
            isSocketConnected = true
            
            if let user = UserModel.getCurrentUserFromDefault() {
                let dictionary : [String:Any] = [ktoken:user.token,
                                                 khookMethod: AppConstant.WebSocketAPI.kregistration]
                self.writeSocketData(dict: dictionary)
            }
            self.pingSocket()
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
            isSocketConnected = false
            
            self.connectSocket()
        case .text(let textstring):
            print(textstring)
            
            let dict = textstring.toJSON() as? [String:AnyObject]
            print(dict as Any)
            
            if let del = self.delegate{
                del.SendReceiveData(dict: dict ?? [:])
            }
        case .binary(let data):
            print(data)
        case .pong(let value):
            break
            //print(value as Any)
        case .ping(let value):
            break
            //print(value as Any)
        case .error(let value):
            print(value as Any)
            self.connectSocket()
        case .viabilityChanged(let value):
            print(value)
        case .reconnectSuggested(let value):
            print(value)
        case .cancelled:
            print("cancelled")
            isSocketConnected = false
            //self.Socket?.connect()
            self.connectSocket()
        }
    }
}
