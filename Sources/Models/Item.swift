// ─────────────────────────────────────────────────────────────────
// Item.swift — Baseline SwiftData model
//
// This file exists to prove the persistence layer is wired correctly
// on first boot. Botflow replaces or supplements this model once the
// user's domain is known.
//
// Botflow injection points:
//   • Add properties directly to this class, or
//   • Delete this file and replace it with domain-specific models —
//     just remember to update the schema array in MyApp.swift.
// ─────────────────────────────────────────────────────────────────

import Foundation
import SwiftData

// @Model macro synthesises PersistentModel conformance, an initialiser,
// and the backing storage — no boilerplate needed.
@Model
final class Item {

    // ── Botflow: add your domain properties here ──────────────────
    var timestamp: Date
    var title: String
    // ─────────────────────────────────────────────────────────────

    init(
        timestamp: Date = .now,
        title: String = ""
    ) {
        self.timestamp = timestamp
        self.title = title
    }
}
