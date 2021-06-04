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

public class MessagePublisher: Publisher {
    
    public typealias Output = Message
    public typealias Failure = Never
    
    fileprivate var subject = PassthroughSubject<Message, Never>()
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Message == S.Input {
        subject.receive(subscriber: subscriber)
    }
    
    public init() {}
}

public class MessageSubject: MessagePublisher, Subject {
    
    public func send(_ value: Message) {
        subject.send(value)
    }
    
    public func send(completion: Subscribers.Completion<Never>) {
        subject.send(completion: completion)
    }
    
    public func send(subscription: Subscription) {
        subject.send(subscription: subscription)
    }
}

/// メッセージを送信することができるプロトコル
public protocol MessageOutputable {
    var output: MessageSubject { get }
}

/// メッセージを受け取ることができるプロトコル
public protocol MessageInputable {
    var input: MessageSubject { get }
}

/// メッセージの送受信ができるプロトコル
public protocol MessageStreamable: MessageInputable, MessageOutputable {
}

//extension MessageStreamable {
//    /// ストリームを繋ぐ
//    func joint<Stream: MessageStreamable>(_ to: Stream, _ subscribers: inout Set<AnyCancellable>) {
//        input.subscribe(to.input).store(in: &subscribers)
//        to.output.subscribe(output).store(in: &subscribers)
//    }
//}
