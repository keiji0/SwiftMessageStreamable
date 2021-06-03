import XCTest
import Combine
@testable import MessageStream

extension String: Message {
}

enum NodeMessage: Message {
    case foo
    case bar
}

class Node : MessageStreamable {
    
    var output = PassthroughSubject<NodeMessage, Never>()
    var input = PassthroughSubject<NodeMessage, Never>()
    let name: String
    var children: [Node]
    var subscribers = Set<AnyCancellable>()

    init(_ name: String, _ children: [Node] = []) {
        self.name = name
        self.children = children
        
        for child in children {
            // 入力を子に受け流す
            input.subscribe(child.input).store(in: &subscribers)
            // 子の出力を自身の出力とする
            child.output.subscribe(output).store(in: &subscribers)
            child.output.sink{
                print($0)
            }.store(in: &subscribers)
        }
        // 入力の監視
        input.sink{
            print("\(name) input: \($0)")
        }.store(in: &subscribers)
    }
}


final class MessageStreamTests: XCTestCase {
    func testFoo() {
        print("hoge")
    }
}