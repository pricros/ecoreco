//
//  Event.swift
//  ecoreco
//
//  Created by apple on 2016/6/10.
//  Copyright © 2016年 apple. All rights reserved.
//

/// An object that has some tear-down logic
public protocol Disposable {
    func dispose()
}


/// An event provides a mechanism for raising notifications, together with some
/// associated data. Multiple function handlers can be added, with each being invoked,
/// with the event data, when the event is raised.
open class Event<T> {
    
    public typealias EventHandler = (T) -> ()
    
    fileprivate var eventHandlers = [Invocable]()
    
    public init() {
    }
    
    /// Raises the event, invoking all handlers
    open func raise(_ data: T) {
        for handler in self.eventHandlers {
            handler.invoke(data)
        }
    }
    
    /// Adds the given handler
    open func addHandler<U: AnyObject>(_ target: U, handler: @escaping (U) -> EventHandler) -> Disposable {
        let wrapper = EventHandlerWrapper(target: target, handler: handler, event: self)
        eventHandlers.append(wrapper)
        return wrapper
    }
}

// MARK:- Private

// A protocol for a type that can be invoked
private protocol Invocable: class {
    func invoke(_ data: Any)
}

// takes a reference to a handler, as a class method, allowing
// a weak reference to the owning type.
// see: http://oleb.net/blog/2014/07/swift-instance-methods-curried-functions/
private class EventHandlerWrapper<T: AnyObject, U> : Invocable, Disposable {
    weak var target: T?
    let handler: (T) -> (U) -> ()
    let event: Event<U>
    
    init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>){
        self.target = target
        self.handler = handler
        self.event = event;
    }
    
    func invoke(_ data: Any) -> () {
        if let t = target {
            handler(t)(data as! U)
        }
    }
    
    func dispose() {
        event.eventHandlers = event.eventHandlers.filter { $0 !== self }
    }
}

class Observable<T> {
    
    let didChange = Event<(T, T)>()
    fileprivate var value: T
    fileprivate var bNeedAck:Bool
    
    init(_ initialValue: T) {
        value = initialValue
        bNeedAck = false
    }
    
    func set(_ newValue: T) {
        let oldValue = value
        value = newValue
        didChange.raise(oldValue, newValue)
    }
    
    func get() -> T {
        return value
    }
    
    func setNeedAck(_ aNeedAck:Bool){
        bNeedAck = aNeedAck
    }
    
    func isNeedAck() -> Bool{
        return bNeedAck
    }
}
