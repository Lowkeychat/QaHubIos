public protocol ScopingFunctionSupported {
    associatedtype ASelf = Self where ASelf:ScopingFunctionSupported

    func `let`<T>(block:(ASelf)->T) -> T
}

public extension ScopingFunctionSupported{
    @inline(__always)
    @discardableResult
    func `let`<T>(block:(Self)->T) -> T{
        return block(self)
    }
}
