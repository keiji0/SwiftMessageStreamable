//
//  MessageStream.swift
//  
//  
//  Created by keiji0 on 2021/06/03
//  
//

import Combine

/// メッセージ本体
public protocol Message {
}

/// メッセージを送信することができるプロトコル
public protocol MessageOutputable {
    associatedtype Publisher : Combine.Publisher where Publisher.Output: Message
    var output: Publisher { get }
}

/// メッセージを受け取ることができるプロトコル
public protocol MessageInputable {
    associatedtype Publisher : Combine.Publisher where Publisher.Output: Message
    var input: Publisher { get }
}

/// メッセージの送受信ができるプロトコル
public typealias MessageStreamable = MessageInputable & MessageOutputable
