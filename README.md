# IdentifiedSets

The IdentifiedSets module adds the concept of an ‘identified set’ to Swift — a set of elements conforming to `Identifiable` that are added or removed to a set-like by their identifier.

For example:

```swift
// Note: This type is not Hashable or Equatable.
struct Greeting: Identifiable {
	var id: String
	var text: String
}

var greetings: IdentifiedSet<Greeting> = []
var english = Greeting(id: "en", text: "Hello")
greetings.insert(english)
print(greetings) // Contains "Hello".

english.text = "Good day!"
greetings.update(with: english) // Replaces the previous element with the same identifier.
print(greetings) // Contains "Good day!" instead.

// The following are equivalent:
greetings.remove(english)
greetings.remove(id: "en")
print(greetings) // Empty.
```

Identified sets transparently support and forward the `Sendable`, `Equatable`, `Hashable`, `Encodable` and/or `Decodable` implementation of their underlying storage, and encode and decode transparently the same way their storage does. If you use the `IdentifiedSet` type as above, this underlying storage is the built-in Swift `Set` type.

## Traits & Implementation Details

The implementation of `IdentifiedSet` is based on an intermediate public type called `IdentifiedSetWrapper`, which can be used to add semantics similar to the above to any set-like type.

The default type uses a `Set`, but adding a conformance to the `IdentifiedSetWrappable` protocol makes this work with, for example, the `OrderedSet` type from [Swift Collections](https://github.com/apple/swift-collections), and this module contains such a conformance for those types by default as well.

If you're using Swift 6.2 or later, this package exposes a `SwiftCollections` trait that enables or disables this support. If disabled, Swift Collections will not be a dependency, and this package will only depend on the Swift runtime. If you're using Swift 6.1 or earlier, the package compiles as if this trait was enabled.
