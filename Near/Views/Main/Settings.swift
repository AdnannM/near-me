//
//  Settings.swift
//  Near
//
//  Created by Adnann Muratovic on 22.05.25.
//

import SwiftUI

import SwiftUI
import StoreKit

// MARK: – User-visible enums / helpers
enum Appearance: String, CaseIterable, Identifiable {
    case system, light, dark
    var id: String { rawValue }

    /// Map to SwiftUI’s colour schemes
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    var label: String {
        switch self {
        case .system: return "Follow System"
        case .light:  return "Light"
        case .dark:   return "Dark"
        }
    }
}

struct SettingsView: View {
    // ---------- Persisted settings ----------
    @AppStorage("appearance")         private var appearance: Appearance = .system
    @AppStorage("badgeEnabled")       private var badgeEnabled  = true
    @AppStorage("hapticsEnabled")     private var hapticsEnabled = true
    @AppStorage("appLocale")          private var appLocale     = Locale.current.identifier

    // ---------- Transient state ----------
    @State private var unlockSheetShown = false

    // Version / build pulled from Info.plist
    private var versionString: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
        let build   = Bundle.main.infoDictionary?["CFBundleVersion"]            as? String ?? "—"
        return "\(version) (\(build))"
    }

    var body: some View {
        NavigationStack {
            List {
                // ───────────────────────────────────────── GENERAL
                Section("General") {
                    Picker("Appearance", selection: $appearance) {
                        ForEach(Appearance.allCases) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }

                    Toggle("App-icon Badge", isOn: $badgeEnabled)
                    Toggle("Haptics",         isOn: $hapticsEnabled)

                    // Locale override (show only two examples; extend as needed)
                    Picker("Language", selection: $appLocale) {
                        Text("System (\(Locale.current.localizedString(forIdentifier: Locale.current.identifier) ?? "Default"))")
                            .tag(Locale.current.identifier)
                        Text("English").tag("en")
                        Text("Bosanski").tag("bs")
                        // TODO: loop through Bundle.main.localizations if you support many languages
                    }
                }
                
                // 1️⃣  SUPPORT & FEEDBACK  ─────────────────────────────────────────────
                Section("Support and Feedback") {
                    NavigationLink {
                        /*FeatureRequestView() */               // TODO: your destination
                    } label: {
                        Label("Request Features", systemImage: "lightbulb")
                            .symbolRenderingMode(.hierarchical)
                    }

                    NavigationLink {
                       // FeedbackFormView()                  // TODO: your destination
                    } label: {
                        Label("Send Feedback", systemImage: "envelope")
                            .symbolRenderingMode(.hierarchical)
                    }
                }

                // 2️⃣  SUPPORT DEVELOPMENT  ────────────────────────────────────────────
                Section("Support Development") {

                    // custom row: heart on the left, gift on the right
                    Button {
                        unlockSheetShown = true             // shows your StoreKit sheet
                    } label: {
                        HStack {
                            Label("Unlock Premium", systemImage: "heart")
                                .symbolRenderingMode(.hierarchical)

                            Spacer()

                            // trailing icon instead of chevron
                            Image(systemName: "gift")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.secondary)
                        }
                        .contentShape(Rectangle())           // full-width tap target
                    }

                    NavigationLink {                         // rate-us destination optional
                        // You can keep this empty; we’ll jump straight to the App Store
                    } label: {
                        Label("Rate on the App Store", systemImage: "hands.sparkles")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .onTapGesture {
                        // Deep-link straight to your review page
                        if let url = URL(string:
                            "itms-apps://itunes.apple.com/app/id1234567890?action=write-review")
                        {
                            UIApplication.shared.open(url)
                        }
                    }
                }

                
                // ────────────────────────────────────────── ABOUT
                Section("About") {
                    Label("Version \(versionString)", systemImage: "number")
                        .foregroundStyle(.secondary)

                    Link(destination: URL(string: "https://your-privacy-policy.url")!) {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                    }

                    Link(destination: URL(string: "https://your-website.example")!) {
                        Label("Developer Website", systemImage: "globe")
                    }
                }
            }
            .navigationTitle("Settings")
            .listStyle(.insetGrouped)
            // ——— Apply appearance & locale overrides live ———
            .preferredColorScheme(appearance.colorScheme)
            .environment(\.locale, Locale(identifier: appLocale))
            .onChange(of: badgeEnabled) { enabled in
                // TODO: Update/clear UNUserNotificationCenter badge count
            }
            .onChange(of: hapticsEnabled) { enabled in
                // wrap your haptic calls in a helper that respects this flag
            }
        }
    }
}



#Preview {
    NavigationStack {
        SettingsView()
    }
}
