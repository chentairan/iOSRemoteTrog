//
//  ViewController.swift
//  Troggie
//
//  Created by chentairan on 2019/8/22.
//  Copyright © 2019 chentairan. All rights reserved.
//

import UIKit
import SwiftSH
import RBSManager
import CDJoystick

class ViewController: UIViewController {

    @IBOutlet weak var ip_adress: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var joystick: CDJoystick!
    

    var command: Command!
    var shell: Shell!
    var TrogManager: RBSManager?
    var TrogPublisher: RBSPublisher?
    
    var twistx,twisty:CGFloat?
    var enableControl:Bool?
    
    var ip:String?
    var user:String?
    var paswd:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.enableControl = false
        joystick.trackingHandler = { joystickData in
            self.twistx = joystickData.velocity.x
            self.twisty = joystickData.velocity.y
            if self.enableControl == true {
                let message = TwistMessage()
                message.linear?.x = -Double(self.twisty!)
                message.angular?.z = -Double(self.twistx!)
                //message.linear?.y = Double(self.twistx!)
                
                self.TrogPublisher?.publish(message)
            }
        }
        
    }
    @IBAction func Connect() {
        print("Hello!")
        self.ip = ip_adress.text ?? "192.168.1.100"
        self.user = username.text ?? "smerc"
        self.paswd = password.text ?? "12345678"
        
//        let cmd = "ls"
        
//        self.command = Command(host: ip, port: 28626)
//        self.command
//            .connect()
//            .authenticate(.byPassword(username: user, password: paswd))
//            .execute(cmd) { (cmd, result: String?, error) in
//                if let result = result {
//                    print(result)
//                } else {
//                    print(error!)
//                }
//        }
        
        self.shell = Shell(host: self.ip!, port: 22)
        self.shell
            .withCallback { [unowned self] (string: String?, error: String?) in
                DispatchQueue.main.async {
                    if let string = string {
                        print(string)
                    }
                    if let error = error {
                        print(error)
                    }
                }
            }
            .connect()
            .authenticate(.byPassword(username: self.user!, password: self.paswd!))
            .open { [unowned self] (error) in
                if let error = error {
                    print(error)
                } else {
                    self.state.text = "State: connected"
                    self.state.textColor = UIColor .green
                }
        }
        self.shell
            .write("./run.sh\n") { (error) in
                if let error = error {
                    print("\(error)")
                }
                
        }
        print(self.shell.readStringCallback!)

        
    }
    
    
    @IBAction func CreateMap(_ sender: Any) {
        self.shell
            .write("ls\n") { (error) in
            if let error = error {
                print("\(error)")
            }
            
        }
        print(self.shell.readStringCallback!)
        connect2ros()
    }
    
    @IBAction func RunMap(_ sender: Any) {
        self.shell
            .write("ls\n") { (error) in
                if let error = error {
                    print("\(error)")
                }
                
        }
        print(self.shell.readStringCallback!)
    }
    
    @IBAction func Manually(_ sender: Any) {
        self.shell
            .write("ls\n") { (error) in
                if let error = error {
                    print("\(error)")
                }
                
        }
        print(self.shell.readStringCallback!)
        connect2ros()
    }
    
    func connect2ros() {
        //RBSManager.connect(RBSManager)
        self.TrogManager = RBSManager.sharedManager()
        self.TrogPublisher = self.TrogManager?.addPublisher(topic: "/trog_velocity_controller/cmd_vel", messageType: "geometry_msgs/Twist", messageClass: TwistMessage.self)
        
        let socketHost = "ws://" + self.ip! + ":9090"
        
        TrogManager?.connect(address: socketHost)
        
        self.enableControl = true
    }
    
    
    
}

