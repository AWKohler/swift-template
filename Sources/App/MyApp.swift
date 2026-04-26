// ─────────────────────────────────────────────────────────────────
// MyApp.swift — Application entry point
//
// Botflow injection points:
//   • Add new @Model types to the ModelContainer schema array below.
//   • Insert additional Scene types (e.g. DocumentGroup) before the
//     closing brace of `var body`.
//   • Place app-wide environment objects on WindowGroup via
//     `.environment(myObject)`.
// ─────────────────────────────────────────────────────────────────

import SwiftUI
import SwiftData

@main
struct MyApp: App {

    // SwiftData model container — holds the persistent store for all
    // @Model types. Botflow expands the schema array as new models
    // are generated.
    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(
                for:
                    // ── Botflow: append new @Model types here ──
                    Item.self
                // ───────────────────────────────────────────────
            )
        } catch {
            // A container failure at launch is unrecoverable — crash
            // fast so the sandbox surfaces the real error immediately.
            fatalError("SwiftData container failed to initialize: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            // ── Botflow: swap ContentView for your root view here ──
            ContentView()
            // ───────────────────────────────────────────────────────
        }
        .modelContainer(modelContainer)
    }
}
