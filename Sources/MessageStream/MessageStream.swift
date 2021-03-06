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

public class MessagePublisher<MessageType: Message>: Publisher {

    public typealias Output = MessageType
    public typealias Failure = Never
    
    fileprivate var subject = PassthroughSubject<MessageType, Never>()
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, MessageType == S.Input {
        subject.receive(subscriber: subscriber)
    }
    
    public init() { }
}

public class MessageSubject<MessageType: Message>: MessagePublisher<MessageType>, Subject {
    public func send(_ value: MessageType) {
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
    associatedtype Subject : Combine.Subject where Subject.Output : Message, Subject.Failure == Never
    var output: Subject { get }
}

/// メッセージを受け取ることができるプロトコル
public protocol MessageInputable {
    associatedtype Subject : Combine.Subject where Subject.Output : Message, Subject.Failure == Never
    var input: Subject { get }
}

/// メッセージの送受信ができるプロトコル
public protocol MessageStreamable: MessageInputable, MessageOutputable {
}

public extension MessageStreamable {
    
    /// Streamを繋ぐ
    /// - Parameters:
    ///   - target: 対象のStream
    ///   - cancellers: キャンセル一覧
    func joint<Stream: MessageStreamable>(target: Stream, storeIn cancellers: inout Set<AnyCancellable>)
    where Subject.Output == Stream.Subject.Output
    {
        input.subscribe(target.input).store(in: &cancellers)
        target.output.subscribe(output).store(in: &cancellers)
    }
}
