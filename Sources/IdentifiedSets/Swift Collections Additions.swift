
#if SwiftCollections
import Collections

extension OrderedSet: IdentifiedSetWrappable & ElementSequenceConvertible {
    public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let result = self.insert(newMember, at: endIndex)
        return (result.inserted, self[result.index])
    }
    
    public mutating func update(with newMember: Element) -> Element? {
        self.updateOrAppend(newMember)
    }
    
    public typealias ConvertibleElement = Element
}

public typealias IdentifiedOrderedSet<Element: Identifiable> = IdentifiedSetWrapper<OrderedSet<Identified<Element>>, Element>

// -----

extension TreeSet: IdentifiedSetWrappable & ElementSequenceConvertible {
    public typealias ConvertibleElement = Element
}

public typealias IdentifiedTreeSet<Element: Identifiable> = IdentifiedSetWrapper<TreeSet<Identified<Element>>, Element>


#endif
