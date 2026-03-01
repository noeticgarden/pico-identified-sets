
public protocol IdentifiedSetWrappable: Sequence where Element: Hashable {
    func contains(_ element: Element) -> Bool
    mutating func insert(_ newMember: Self.Element) -> (inserted: Bool, memberAfterInsert: Self.Element)
    mutating func remove(_ value: Self.Element) -> Self.Element?
    mutating func update(with newMember: Self.Element) -> Self.Element?
}

extension Set: IdentifiedSetWrappable {}

extension IdentifiedSetWrappable where Element: IdentifiedPlaceholder {
    public subscript(id id: Element.Value.ID) -> Element.Value? {
        let unsafe = Element._unsafePlaceholder(id: id)
        guard self.contains(unsafe) else {
            return nil
        }
        
        var me = self
        return me.insert(unsafe).memberAfterInsert.base
    }
    
    public func contains(id: Element.Value.ID) -> Bool {
        let unsafe = Element._unsafePlaceholder(id: id)
        return contains(unsafe)
    }
    
    public func contains(_ value: Element.Value) -> Bool {
        let unsafe = Element._unsafePlaceholder(id: value.id)
        return contains(unsafe)
    }
    
    @discardableResult
    public mutating func insert(_ newMember: Self.Element.Value) -> (inserted: Bool, memberAfterInsert: Self.Element.Value) {
        let result = insert(Element(newMember))
        return (result.inserted, result.memberAfterInsert.base)
    }
    
    @discardableResult
    public mutating func remove(id: Self.Element.Value.ID) -> Self.Element.Value? {
        remove(Element._unsafePlaceholder(id: id))?.base
    }
    
    @discardableResult
    public mutating func remove(_ value: Self.Element.Value) -> Self.Element.Value? {
        remove(Element._unsafePlaceholder(id: value.id))?.base
    }
    
    @discardableResult
    public mutating func update(with newMember: Self.Element.Value) -> Self.Element.Value? {
        self.update(with: Element(newMember))?.base
    }
}

extension Sequence where Element: IdentifiedPlaceholder {
    public var identifiables: some Sequence<Element.Value> {
        self.lazy.map(\.base)
    }
}

extension Sequence where Element: Identifiable {
    public var byIdentifier: Set<Identified<Element>> {
        Set(self.lazy.map { Identified($0) })
    }
}
