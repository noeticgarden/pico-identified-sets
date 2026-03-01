
public struct IdentifiedSetWrapper<Base: IdentifiedSetWrappable, Element: Identifiable> where Base.Element == Identified<Element> {
    public var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public typealias IdentifiedSet<Element: Identifiable> = IdentifiedSetWrapper<Set<Identified<Element>>, Element>

extension IdentifiedSetWrapper: Encodable where Base: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(base)
    }
}

extension IdentifiedSetWrapper: Decodable where Base: Decodable {
    enum CodingKeys: CodingKey {
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try container.decode(Base.self)
    }
}

extension IdentifiedSetWrapper: Sendable where Base: Sendable, Element.ID: Sendable {}
extension IdentifiedSetWrapper: Equatable where Base: Equatable, Element: Equatable {
    public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.base == rhs.base && lhs.allSatisfy { identified in
            identified == rhs.base[id: identified.id]
        }
    }
}
extension IdentifiedSetWrapper: Hashable where Base: Equatable, Element: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.map(\.id).hash(into: &hasher)
    }
}

extension IdentifiedSetWrapper where Base == Set<Identified<Element>> {
    public init(_ sequence: some Sequence<Identified<Element>>) {
        self.base = Set(sequence)
    }
    
    public init(_ sequence: some Sequence<Element>) {
        self.base = Set(sequence.lazy.map {
            Identified($0)
        })
    }
}

extension IdentifiedSetWrapper: Sequence {
    public func makeIterator() -> Iterator {
        .init(real: base.makeIterator())
    }
    
    public struct Iterator: IteratorProtocol {
        var real: Base.Iterator
        public mutating func next() -> Element? {
            real.next()?.base
        }
    }
}

extension IdentifiedSetWrapper: Collection where Base: Collection {
    public func index(after i: Index) -> Index {
        .init(real: base.index(after: i.real))
    }
    
    public subscript(position: Index) -> Element {
        base[position.real].base
    }
    
    public subscript(id id: Element.ID) -> Element? {
        base[id: id]
    }
    
    public var isEmpty: Bool {
        base.isEmpty
    }
    
    public var startIndex: Index {
        .init(real: base.startIndex)
    }
    
    public var endIndex: Index {
        .init(real: base.endIndex)
    }
    
    public struct Index: Comparable {
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.real < rhs.real
        }
        
        var real: Base.Index
    }
}

public protocol ElementSequenceConvertible {
    associatedtype ConvertibleElement
    init(_ content: some Sequence<ConvertibleElement>)
    init()
}

extension Set: ElementSequenceConvertible {
    public typealias ConvertibleElement = Element
}

extension IdentifiedSetWrapper: ExpressibleByArrayLiteral where Base: ElementSequenceConvertible, Base.ConvertibleElement == Identified<Element> {
    public init(arrayLiteral elements: Element...) {
        self.init(Base(elements.map { Identified($0) }))
    }
}

extension IdentifiedSetWrapper: ElementSequenceConvertible where Base: ElementSequenceConvertible, Base.ConvertibleElement == Identified<Element> {
    public typealias ConvertibleElement = Element
    
    public init() {
        self.init(Base())
    }
    
    public init(_ content: some Sequence<Element>) {
        self.init(Base(content.map { .init($0) }))
    }
}

extension IdentifiedSetWrapper: SetAlgebra where Base: SetAlgebra & ElementSequenceConvertible, Element: Equatable, Element.ID: Equatable, Base.ConvertibleElement == Identified<Element> {}

extension IdentifiedSetWrapper {
    public func contains(_ member: Element) -> Bool {
        base.contains(id: member.id)
    }
    
    public func contains(id: Self.Element.ID) -> Bool {
        base.contains(id: id)
    }
    
    @discardableResult
    public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let result = base.insert(Identified(newMember))
        return (result.inserted, result.memberAfterInsert.base)
    }
    
    @discardableResult
    public mutating func remove(_ member: Element) -> Element? {
        base.remove(id: member.id)
    }
    
    @discardableResult
    public mutating func remove(id: Self.Element.ID) -> Self.Element? {
        base.remove(id: id)
    }
    
    @discardableResult
    public mutating func update(with newMember: Element) -> Element? {
        base.update(with: Identified(newMember))?.base
    }
}

extension IdentifiedSetWrapper where Base: SetAlgebra & ElementSequenceConvertible, Base.ConvertibleElement == Identified<Element> {
    public func union(_ other: Self) -> Self {
        .init(base.union(other.base))
    }
    
    public func intersection(_ other: Self) -> Self {
        .init(base.intersection(other.base))
    }
    
    public func symmetricDifference(_ other: __owned Self) -> Self {
        .init(base.symmetricDifference(other.base))
    }
    
    public mutating func formUnion(_ other: __owned Self) {
        base.formUnion(other.base)
    }
    
    public mutating func formIntersection(_ other: Self) {
        base.formIntersection(other.base)
    }
    
    public mutating func formSymmetricDifference(_ other: __owned Self) {
        base.formSymmetricDifference(other.base)
    }
}
