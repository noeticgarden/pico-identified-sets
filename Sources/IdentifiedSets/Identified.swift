
public protocol IdentifiedPlaceholder: Hashable {
    associatedtype Value: Identifiable
    var base: Value { get }
    
    init(_ base: Value)
    static func _unsafePlaceholder(id: Value.ID) -> Self
}

public struct Identified<Value: Identifiable>: Hashable, IdentifiedPlaceholder {
    public init(_ base: Value) {
        self.storage = .value(base)
    }
    
    init(_unsafeID id: Value.ID) {
        self.storage = .unsafeID(id)
    }
    
    public static func _unsafePlaceholder(id: Value.ID) -> Identified<Value> {
        .init(_unsafeID: id)
    }
    
    public var base: Value {
        get {
            switch storage {
            case .value(let value):
                value
            case .unsafeID:
                fatalError("This is an unsafe placeholder, used for set algebra operations only. It can be hashed and compared, but has no underlying value.")
            }
        }
        set {
            self.storage = .value(newValue)
        }
    }
    
    var storage: Storage
    enum Storage {
        case value(Value)
        case unsafeID(Value.ID)
    }
    
    public var id: Value.ID {
        switch storage {
        case .value(let value):
            value.id
        case .unsafeID(let id):
            id
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension Identified: Sendable where Value: Sendable, Value.ID: Sendable {}
extension Identified.Storage: Sendable where Value: Sendable, Value.ID: Sendable {}

extension Identified: Comparable where Value: Comparable {
    public static func < (_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.base < rhs.base
    }
}

extension Identified: Decodable where Value: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(try container.decode(Value.self))
    }
}

extension Identified: Encodable where Value: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(base)
    }
}
