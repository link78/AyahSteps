//
//  SubscriptionView.swift
//  DeenLearn
//
//  Created by DeenLearn Team
//

import SwiftUI
import StoreKit

// MARK: - Main Subscription View

struct SubscriptionView: View {
    @StateObject private var subscriptionService = SubscriptionService.shared
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: SubscriptionPlan = .yearly
    @State private var showingTerms = false
    @State private var showingPrivacy = false
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Current Plan Badge (if subscribed)
                    if subscriptionService.isSubscribed {
                        currentPlanBadge
                    }
                    
                    // Plan Cards
                    planCardsSection
                    
                    // Feature Comparison
                    featureComparisonSection
                    
                    // Subscribe Button
                    if !subscriptionService.isSubscribed {
                        subscribeButton
                    }
                    
                    // Restore Purchases
                    restorePurchasesButton
                    
                    // Legal Links
                    legalLinksSection
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("DeenLearn Plus")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .sheet(isPresented: $showingTerms) {
            TermsOfServiceView()
        }
        .sheet(isPresented: $showingPrivacy) {
            PrivacyPolicyView()
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Logo/Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            Text("Upgrade to DeenLearn Plus")
                .font(.title2.bold())
            
            Text("Unlock the full Islamic learning experience")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top)
    }
    
    // MARK: - Current Plan Badge
    
    private var currentPlanBadge: some View {
        HStack {
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.green)
            
            Text("You're subscribed to \(subscriptionService.currentPlan.name)")
                .font(.subheadline.bold())
            
            Spacer()
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Plan Cards
    
    private var planCardsSection: some View {
        VStack(spacing: 16) {
            Text("Choose Your Plan")
                .font(.headline)
            
            HStack(spacing: 12) {
                // Monthly Plan
                PlanCard(
                    plan: .monthly,
                    isSelected: selectedPlan == .monthly,
                    action: { selectedPlan = .monthly }
                )
                
                // Yearly Plan
                PlanCard(
                    plan: .yearly,
                    isSelected: selectedPlan == .yearly,
                    action: { selectedPlan = .yearly }
                )
            }
        }
    }
    
    // MARK: - Feature Comparison
    
    private var featureComparisonSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What You Get")
                .font(.headline)
            
            VStack(spacing: 0) {
                ForEach(PremiumFeature.allCases, id: \.rawValue) { feature in
                    FeatureRow(feature: feature)
                    
                    if feature != PremiumFeature.allCases.last {
                        Divider()
                    }
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Subscribe Button
    
    private var subscribeButton: some View {
        Button(action: {
            Task {
                await subscribe()
            }
        }) {
            HStack {
                if isPurchasing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Subscribe for \(selectedPlan.price)")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(14)
        }
        .disabled(isPurchasing)
    }
    
    // MARK: - Restore Purchases
    
    private var restorePurchasesButton: some View {
        Button("Restore Purchases") {
            Task {
                await subscriptionService.restorePurchases()
            }
        }
        .font(.subheadline)
        .foregroundColor(.blue)
    }
    
    // MARK: - Legal Links
    
    private var legalLinksSection: some View {
        VStack(spacing: 8) {
            HStack(spacing: 16) {
                Button("Terms of Service") {
                    showingTerms = true
                }
                
                Text("•")
                
                Button("Privacy Policy") {
                    showingPrivacy = true
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            Text("Subscriptions will automatically renew unless canceled at least 24 hours before the end of the current period. You can manage your subscription in your App Store account settings.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    // MARK: - Actions
    
    private func subscribe() async {
        isPurchasing = true
        defer { isPurchasing = false }
        
        do {
            let success = try await subscriptionService.purchase(selectedPlan)
            if success {
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

// MARK: - Plan Card

struct PlanCard: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Best Value Badge
                if plan.isBestValue {
                    Text("BEST VALUE")
                        .font(.caption2.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                } else {
                    Spacer()
                        .frame(height: 20)
                }
                
                Text(plan.displayName)
                    .font(.headline)
                
                Text(plan.price)
                    .font(.title3.bold())
                    .foregroundColor(isSelected ? .white : .primary)
                
                if let savings = plan.savingsPercentage {
                    Text("Save \(savings)%")
                        .font(.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .green)
                }
                
                // Per month breakdown for yearly
                if plan == .yearly {
                    Text("~$3.33/month")
                        .font(.caption2)
                        .foregroundColor(isSelected ? .white.opacity(0.7) : .secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                isSelected ?
                LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ) :
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemBackground)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let feature: PremiumFeature
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: feature.icon)
                .font(.system(size: 20))
                .foregroundColor(.purple)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(feature.displayName)
                    .font(.subheadline.bold())
                
                Text(feature.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
        .padding()
    }
}

// MARK: - Paywall View (Compact)

struct PaywallView: View {
    let feature: String
    let onUpgrade: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // Lock Icon
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "lock.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.orange)
            }
            
            Text("Premium Feature")
                .font(.title2.bold())
            
            Text("\(feature) is available with DeenLearn Plus")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Benefits
            VStack(alignment: .leading, spacing: 8) {
                BenefitRow(text: "Full Salah Trainer (all 5 prayers)")
                BenefitRow(text: "Complete Quran with audio")
                BenefitRow(text: "All 28 Arabic letters")
                BenefitRow(text: "Unlimited child profiles")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Upgrade Button
            Button(action: onUpgrade) {
                Text("Upgrade to Plus")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            
            Button("Maybe Later") {
                dismiss()
            }
            .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct BenefitRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 14))
            
            Text(text)
                .font(.subheadline)
        }
    }
}

// MARK: - Locked Content View

struct LockedContentView: View {
    let title: String
    let description: String
    @State private var showSubscription = false
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.fill")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.headline)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Unlock with Plus") {
                showSubscription = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
        }
        .padding()
        .sheet(isPresented: $showSubscription) {
            SubscriptionView()
        }
    }
}

// MARK: - Premium Badge

struct PremiumBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: 10))
            Text("PLUS")
                .font(.caption2.bold())
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(
            LinearGradient(
                colors: [.purple, .blue],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .foregroundColor(.white)
        .cornerRadius(4)
    }
}

// MARK: - Lock Overlay

struct LockOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            
            VStack(spacing: 8) {
                Image(systemName: "lock.fill")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("Plus")
                    .font(.caption.bold())
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Terms of Service View

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Terms of Service")
                        .font(.title.bold())
                    
                    Text("""
                    Welcome to DeenLearn. By using our app, you agree to these terms.
                    
                    1. Subscription Terms
                    - DeenLearn Plus subscriptions automatically renew unless canceled
                    - Cancel at least 24 hours before renewal to avoid charges
                    - Manage subscriptions in App Store settings
                    
                    2. Content Usage
                    - Content is for personal, non-commercial use
                    - Islamic content is provided for educational purposes
                    - Users should verify religious guidance with qualified scholars
                    
                    3. User Accounts
                    - Parents are responsible for child accounts
                    - Keep account credentials secure
                    - One account per person
                    
                    4. Refunds
                    - Refund requests handled through Apple
                    - Contact support for assistance
                    
                    5. Changes to Terms
                    - We may update these terms periodically
                    - Continued use implies acceptance
                    
                    Contact: support@deenlearn.app
                    """)
                    .font(.body)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Privacy Policy View

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Privacy Policy")
                        .font(.title.bold())
                    
                    Text("""
                    DeenLearn is committed to protecting your privacy.
                    
                    1. Data Collection
                    - We collect minimal data needed for app functionality
                    - Learning progress is stored locally on your device
                    - No personal data is shared with third parties
                    
                    2. Children's Privacy
                    - We comply with COPPA requirements
                    - No data collection from children under 13 without parental consent
                    - Parents can review and delete child data
                    
                    3. Analytics
                    - We use anonymous analytics to improve the app
                    - No personally identifiable information is tracked
                    
                    4. Data Security
                    - Data is encrypted in transit and at rest
                    - We use industry-standard security measures
                    
                    5. Your Rights
                    - Request data deletion at any time
                    - Opt out of analytics in settings
                    
                    Contact: privacy@deenlearn.app
                    """)
                    .font(.body)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}
