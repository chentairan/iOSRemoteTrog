//
//  TwistStampedMessage.swift
//  Pods
//
//  Created by Jason Pack on 2018-11-13.
//
import UIKit
import ObjectMapper
import RBSManager

public class PoseStampedMessage: RBSMessage {
    public var header: HeaderMessage?
    public var pose: PoseMessage?
    
    public override init() {
        super.init()
        header = HeaderMessage()
        pose = PoseMessage()
    }
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        header <- map["header"]
        pose <- map["pose"]
    }
}
