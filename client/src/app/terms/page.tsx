import Link from "next/link";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Terms of Service",
  description: "Terms of Service for Early Reader Phonics app",
};

export default function TermsPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-pink-50 via-purple-50 to-blue-50 text-slate-900">
      <main className="relative mx-auto flex max-w-4xl flex-col gap-8 px-6 pb-20 pt-12">
        {/* Header */}
        <header className="text-center">
          <Link
            href="/"
            className="inline-flex items-center gap-2 text-sm font-semibold text-[var(--vibrant-lavender)] hover:underline mb-6"
          >
            <span>←</span> Back to Home
          </Link>
          <h1 className="font-[family-name:var(--font-geist-mono)] text-4xl font-bold text-slate-900 md:text-5xl mb-4">
            Terms of Service
          </h1>
          <p className="text-slate-600 text-lg">
            Last Updated: November 29, 2025
          </p>
        </header>

        {/* Content */}
        <div className="rounded-3xl border border-white/50 bg-white/95 p-8 md:p-12 shadow-xl backdrop-blur space-y-8">
          <section className="space-y-4">
            <h2 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900">
              1. Acceptance of Terms
            </h2>
            <p className="text-slate-700 leading-relaxed">
              By downloading, installing, or using Early Reader Phonics ("the App"), you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the App.
            </p>
          </section>

          <section className="space-y-4">
            <h2 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900">
              2. License to Use
            </h2>
            <p className="text-slate-700 leading-relaxed">
              We grant you a limited, non-exclusive, non-transferable, revocable license to use the App for personal, non-commercial purposes, subject to these Terms of Service.
            </p>
          </section>

          <section className="space-y-4">
            <h2 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900">
              3. Purchases and Payments
            </h2>
            <div className="space-y-3 text-slate-700 leading-relaxed">
              <p>
                <strong>In-App Purchases:</strong> The App offers a premium version unlocked through a one-time in-app purchase. All payments are processed securely through Apple's App Store.
              </p>
              <p>
                <strong>Pricing:</strong> Prices are displayed in your local currency and may vary by region. Apple sets all prices and handles billing.
              </p>
              <p>
                <strong>Refunds:</strong> All sales are final. Refund requests must be submitted directly to Apple through the App Store. We do not have access to process refunds.
              </p>
              <p>
                <strong>Restoring Purchases:</strong> If you reinstall the App or use it on a new device, you can restore your premium purchase at no additional cost using the same Apple ID.
              </p>
            </div>
          </section>

          <section className="space-y-4">
            <h2 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900">
              4. User Responsibilities
            </h2>
            <p className="text-slate-700 leading-relaxed">
              You agree to use the App only for lawful purposes and in accordance with these Terms. You are responsible for:
            </p>
            <ul className="list-disc list-inside space-y-2 text-slate-700 pl-4">
              <li>Maintaining the security of your device and Apple ID</li>
              <li>Supervising children's use of the App</li>
              <li>Not attempting to reverse engineer, decompile, or disassemble the App</li>
              <li>Not using the App in any way that could damage or impair our services</li>
            </ul>
          </section>

          <section className="space-y-4">
            <h2 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900">
              5. Intellectual Property
            </h2>
            <p className="text-slate-700 leading-relaxed">
              All content, features, and functionality of the App, including but not limited to text, graphics, logos, icons, images, audio clips, and software, are the exclusive property of Early Reader Phonics and are protected by copyright, trademark, and other intellectual property laws.
            </p>
          </section>

          <section className="space-y-4">
            <h2 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900">
              6. Privacy and Data
            </h2>
            <p className="text-slate-700 leading-relaxed">
              Your privacy is important to us. All user data, including profiles and progress, is stored locally on your device. We do not collect, transmit, or share personal information. For more details, please review our{" "}
              <Link href="/#privacy-policy" className="text-[var(--vibrant-lavender)] font-semibold hover:underline">
                Privacy Policy
              </Link>.
            </p>
          </section>

          <section className="space-y-4">
            <h2 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900">
              7. Disclaimers and Limitations
            </h2>
            <div className="space-y-3 text-slate-700 leading-relaxed">
              <p>
                <strong>Educational Tool:</strong> Early Reader Phonics is designed to supplement reading instruction. It is not a replacement for professional educational services or medical advice.
              </p>
              <p>
                <strong>No Warranties:</strong> The App is provided "as is" and "as available" without warranties of any kind, either express or implied.
              </p>
              <p>
                <strong>Limitation of Liability:</strong> To the fullest extent permitted by law, Early Reader Phonics shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of the App.
              </p>
            </div>
          </section>

          <section className="space-y-4">
            <h2 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900">
              8. Updates and Changes
            </h2>
            <p className="text-slate-700 leading-relaxed">
              We reserve the right to modify, suspend, or discontinue the App or any part thereof at any time. We may also update these Terms of Service periodically. Continued use of the App after changes constitutes acceptance of the updated terms.
            </p>
          </section>

          <section className="space-y-4">
            <h2 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900">
              9. Termination
            </h2>
            <p className="text-slate-700 leading-relaxed">
              We reserve the right to terminate or suspend your access to the App at our sole discretion, without notice, for conduct that we believe violates these Terms or is harmful to other users, us, or third parties.
            </p>
          </section>

          <section className="space-y-4">
            <h2 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900">
              10. Governing Law
            </h2>
            <p className="text-slate-700 leading-relaxed">
              These Terms shall be governed by and construed in accordance with the laws of your jurisdiction, without regard to its conflict of law provisions.
            </p>
          </section>

          <section className="space-y-4">
            <h2 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900">
              11. Contact Information
            </h2>
            <p className="text-slate-700 leading-relaxed">
              If you have any questions about these Terms of Service, please contact us at:
            </p>
            <div className="rounded-xl border-2 border-[var(--vibrant-lavender)] bg-purple-50 p-5">
              <p className="text-slate-900 font-semibold mb-1">Email Support</p>
              <a
                href="mailto:support@earlyreader.app"
                className="text-[var(--vibrant-lavender)] font-bold text-lg hover:underline"
              >
                support@earlyreader.app
              </a>
            </div>
          </section>

          <section className="pt-6 border-t border-slate-200">
            <p className="text-sm text-slate-600 italic">
              By using Early Reader Phonics, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.
            </p>
          </section>
        </div>

        {/* Footer Navigation */}
        <div className="text-center space-y-4">
          <div className="flex flex-wrap gap-4 justify-center text-sm">
            <Link
              href="/"
              className="text-[var(--vibrant-lavender)] hover:underline font-medium"
            >
              Home
            </Link>
            <span className="text-slate-300">•</span>
            <Link
              href="/#privacy-policy"
              className="text-[var(--vibrant-lavender)] hover:underline font-medium"
            >
              Privacy Policy
            </Link>
            <span className="text-slate-300">•</span>
            <Link
              href="/#contact"
              className="text-[var(--vibrant-lavender)] hover:underline font-medium"
            >
              Contact Us
            </Link>
          </div>
          <p className="text-xs text-slate-500">
            © {new Date().getFullYear()} Early Reader Phonics. All rights reserved.
          </p>
        </div>
      </main>
    </div>
  );
}
