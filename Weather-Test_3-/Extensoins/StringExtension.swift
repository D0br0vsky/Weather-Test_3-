import Foundation

extension String {
    var countryName: String {
        return Locale.current.localizedString(forRegionCode: self) ?? self
    }
}
