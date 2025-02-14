extension Double {
    func roundedInt(rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Int {
        return Int(self.rounded(rule))
    }
}
