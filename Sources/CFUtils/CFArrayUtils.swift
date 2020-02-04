import Foundation

public enum CFArrayUtlsError: Error, LocalizedError {
	case invalidPointer

	public var localizedDescription: String {
		switch self {
		case .invalidPointer:
			return "Invalid pointer."
		}
	}
}

extension CFArray {

	/// Creates a new mutable copy.
	public func mutableCopy() -> CFMutableArray? {
		let count = self.count
		return CFArrayCreateMutableCopy(nil, count, self)
	}

	/// Gets count of the items in the array
	public var count: Int {
		return CFArrayGetCount(self)
	}

	/// Converts a CFArray to a Swift array
	/// - Parameter type: Item type in the new array.
	func convertToArray<T>(of type: T.Type) throws -> [T]  {
		let count = self.count
		var items = [T]()
		for i in 0..<count {
			let item = try self.item(at: i, of: type)
			items.append(item)
		}
		return items
	}

	/// Gets item at a given index.
	/// - Parameters:
	///   - index: The index.
	///   - type: The desired item type.
	func item<T>(at index:Int, of type: T.Type) throws -> T {
		guard let ptr = CFArrayGetValueAtIndex(self, index) else {
			throw CFArrayUtlsError.invalidPointer
		}
		let item = ptr.assumingMemoryBound(to: T.self).pointee
		return item
	}

	/// Converts to a new Swift array by a given transformation closure.
	/// - Parameter transform: The closure.
	func map<T>(transform: (UnsafeRawPointer)->T) throws -> [T] {
		let count = self.count
		var items = [T]()
		for i in 0..<count {
			guard let ptr = CFArrayGetValueAtIndex(self, i) else {
				throw CFArrayUtlsError.invalidPointer
			}
			let item = transform(ptr)
			items.append(item)
		}
		return items
	}

	/// Converts to an array of the given type, then converts to another array by a closure.
	/// - Parameters:
	///   - type: The type.
	///   - transform: The closure.
	func map<U, T>(type: U.Type, transform: (U)->T) throws -> [T] {
		let count = self.count
		var items = [T]()
		for i in 0..<count {
			let item = try self.item(at: i, of: type)
			items.append(transform(item))
		}
		return items
	}

}

extension CFMutableArray {

	/// Remove item at a given index.
	/// - Parameter index: The index.
	public func remove(at index:Int) {
		CFArrayRemoveValueAtIndex(self, index)
	}

	/// Removes all values.
	public func removeAll() {
		CFArrayRemoveAllValues(self)
	}
}
