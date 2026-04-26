// ─────────────────────────────────────────────────────────────────
// ContentView.swift — Botflow welcome / environment-check screen
//
// Shown on first launch to confirm the sandbox is healthy.
// Botflow replaces this view's body (or the entire file) once the
// user's first prompt produces a real UI.
//
// Botflow injection points:
//   • Replace the body below with the generated root view, OR
//   • Keep this as a splash and push a NavigationStack destination.
// ─────────────────────────────────────────────────────────────────

import SwiftUI
import SwiftData

struct ContentView: View {

    // SwiftData smoke-test: a successful @Query confirms the
    // ModelContainer is reachable without a crash on boot.
    @Query private var items: [Item]

    // Drives the ambient pulse animation on the hero symbol.
    @State private var isPulsing: Bool = false

    // Controls the staggered fade-in of each content block.
    @State private var heroVisible: Bool    = false
    @State private var titleVisible: Bool   = false
    @State private var badgeVisible: Bool   = false

    var body: some View {
        ZStack {
            background

            VStack(spacing: 0) {
                Spacer()
                heroSymbol
                Spacer().frame(height: 40)
                headline
                Spacer()
                poweredBadge
                    .padding(.bottom, 40)
            }
            .padding(.horizontal, 32)
        }
        .onAppear { animateIn() }
    }

    // ── Background ───────────────────────────────────────────────

    private var background: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Soft radial bloom behind the hero icon
            RadialGradient(
                colors: [
                    Color(red: 0.28, green: 0.14, blue: 0.72).opacity(0.55),
                    Color.clear
                ],
                center: .init(x: 0.5, y: 0.38),
                startRadius: 0,
                endRadius: 340
            )
            .ignoresSafeArea()
        }
    }

    // ── Hero symbol ──────────────────────────────────────────────

    private var heroSymbol: some View {
        ZStack {
            // Glowing halo ring
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.purple.opacity(isPulsing ? 0.22 : 0.10),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 90
                    )
                )
                .frame(width: 180, height: 180)
                .scaleEffect(isPulsing ? 1.12 : 0.92)
                .animation(
                    .easeInOut(duration: 2.4).repeatForever(autoreverses: true),
                    value: isPulsing
                )

            // SF Symbol
            Image(systemName: "sparkles")
                .font(.system(size: 72, weight: .ultraLight))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 0.60, green: 0.42, blue: 1.00),
                            Color(red: 0.85, green: 0.52, blue: 1.00),
                            Color(red: 1.00, green: 0.65, blue: 0.85)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(isPulsing ? 1.07 : 1.00)
                .shadow(color: .purple.opacity(0.7), radius: isPulsing ? 28 : 12, y: 6)
                .animation(
                    .easeInOut(duration: 2.4).repeatForever(autoreverses: true),
                    value: isPulsing
                )
        }
        .opacity(heroVisible ? 1 : 0)
        .scaleEffect(heroVisible ? 1 : 0.80)
    }

    // ── Headline block ───────────────────────────────────────────

    private var headline: some View {
        VStack(spacing: 14) {
            Text("Ready to Build.")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text("Your environment is linked.\nPrompt the AI to start building your app.")
                .font(.system(size: 17, weight: .regular, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.52))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .opacity(titleVisible ? 1 : 0)
        .offset(y: titleVisible ? 0 : 12)
    }

    // ── Powered-by badge ─────────────────────────────────────────

    private var poweredBadge: some View {
        HStack(spacing: 5) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 11, weight: .semibold))
            Text("Powered by Botflow")
                .font(.system(size: 13, weight: .medium, design: .rounded))
        }
        .foregroundStyle(Color.white.opacity(0.28))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .strokeBorder(Color.white.opacity(0.09), lineWidth: 1)
        )
        .opacity(badgeVisible ? 1 : 0)
    }

    // ── Animation sequence ───────────────────────────────────────

    private func animateIn() {
        isPulsing = true

        withAnimation(.spring(duration: 0.7, bounce: 0.3)) {
            heroVisible = true
        }
        withAnimation(.easeOut(duration: 0.55).delay(0.25)) {
            titleVisible = true
        }
        withAnimation(.easeOut(duration: 0.45).delay(0.55)) {
            badgeVisible = true
        }
    }
}

// ── Preview ───────────────────────────────────────────────────────

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
