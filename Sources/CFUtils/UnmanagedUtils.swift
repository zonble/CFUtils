import Foundation

extension Unmanaged where Instance : CFString {
	/// Converts a pointer to a CFString to a Swift string.
	public var stringValue: String? {
		return self.takeUnretainedValue() as? String
	}
}
