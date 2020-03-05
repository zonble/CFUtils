import Foundation

extension OSStatus {
	/// Converts an OSStatus to a string.
	public var stringValue: String? {
		withUnsafeBytes(of: self) {
			String(bytes: $0, encoding: .ascii)
		}
	}

	/// If the status is noErr.
	public var isNoErr: Bool {
		return self == noErr
	}

	/// Gets error object from an OSStatus code.
	public var error: Error? {
		if self == noErr {
			return nil
		}
		let error = NSError(domain: "OSStatusError", code: Int(self), userInfo:[NSLocalizedDescriptionKey: "Error: \(self.stringValue ?? "\(Int(self))")"])
		return error
	}
}
