//
//  PoseMessage.swift
//  ObjectMapper
//
//  Created by Wes Goodhoofd on 2018-01-10.
//
import UIKit
import ObjectMapper
import RBSManager

public class PoseMessage: RBSMessage {
    public var position: PointMessage?
    public var orientation: QuaternionMessage?
    
    public override init() {
        super.init()
        position = PointMessage()
        orientation = QuaternionMessage()
    }
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        position <- map["position"]
        orientation <- map["orientation"]
    }
}
