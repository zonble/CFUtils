import Foundation

extension Unmanaged where Instance : CFString {
	/// Converts to a Swift string.
	var stringValue: String? {
		return self.takeUnretainedValue() as? String
	}
}
