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

	func item<T>(at index:Int, of type: T.Type) throws -> T {
		guard let ptr = CFArrayGetValueAtIndex(self, index) else {
			throw CFArrayUtlsError.invalidPointer
		}
		let item = ptr.assumingMemoryBound(to: T.self).pointee
		return item
	}

}
