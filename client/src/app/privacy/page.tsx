'use client';

import Link from "next/link";
import Image from "next/image";
import { useEffect, useState } from "react";

export default function Privacy() {
  const [showScrollTop, setShowScrollTop] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setShowScrollTop(window.scrollY > 400);
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-br from-pink-50 via-purple-50 to-blue-50 text-slate-900 scroll-smooth">
      {/* Decorative background elements */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-10 left-10 w-72 h-72 bg-[var(--vibrant-pink)] rounded-full opacity-10 blur-3xl" />
        <div className="absolute top-40 right-20 w-96 h-96 bg-[var(--vibrant-lavender)] rounded-full opacity-10 blur-3xl" />
        <div className="absolute bottom-20 left-1/3 w-80 h-80 bg-[var(--vibrant-mint)] rounded-full opacity-10 blur-3xl" />
      </div>

      {/* Fixed Header */}
      <header className="fixed top-0 left-0 right-0 z-50 border-b border-white/50 bg-white/95 backdrop-blur-lg shadow-sm">
        <div className="mx-auto max-w-none xl:max-w-[90vw] 2xl:max-w-[1600px] px-6 py-4 md:px-10 lg:px-16 xl:px-20">
          <div className="flex items-center justify-between">
            <Link
              href="/"
              className="inline-flex items-center gap-2 text-sm font-medium text-slate-600 hover:text-[var(--vibrant-lavender)] transition"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
              </svg>
              Back to Home
            </Link>
            <div className="flex items-center gap-3">
              <div className="hidden md:block">
                <h1 className="font-[family-name:var(--font-geist-mono)] text-xl font-bold text-slate-900">
                  Privacy Policy
                </h1>
              </div>
              <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-white p-2 ring-2 ring-slate-200 shadow-md">
                <Image
                  src="/note-early-icon-logo-white.png"
                  alt="Early Reader Phonics"
                  width={48}
                  height={48}
                  className="w-full h-full object-contain"
                />
              </div>
            </div>
          </div>
        </div>
      </header>

      <main className="relative mx-auto flex w-full max-w-none xl:max-w-[90vw] 2xl:max-w-[1600px] flex-col gap-16 px-6 pb-20 pt-32 md:px-10 lg:px-16 xl:px-20 md:pt-36">
        {/* Hero Section */}
        <section className="space-y-6">
          <div className="text-center space-y-4">
            <h2 className="font-[family-name:var(--font-geist-mono)] text-3xl font-bold text-slate-900 md:text-4xl md:hidden">
              Privacy Policy
            </h2>
            <p className="text-lg text-slate-600 max-w-2xl mx-auto">
              Your privacy is our priority. Learn how we protect your family's data.
            </p>
          </div>
        </section>

        {/* Privacy Overview */}
        <section className="rounded-3xl border border-white/50 bg-white/95 p-8 shadow-xl backdrop-blur md:p-12">
          <div className="space-y-6">
            <div className="text-center max-w-3xl mx-auto">
              <p className="text-sm font-bold uppercase tracking-widest text-[var(--vibrant-lilac)] mb-3">
                🔒 Privacy
              </p>
              <h2 className="font-[family-name:var(--font-geist-mono)] text-3xl font-bold text-slate-900 md:text-4xl mb-3">
                Your privacy matters
              </h2>
              <p className="text-lg text-slate-600 leading-relaxed">
                Early Reader Phonics is built for kids and families. We keep all data on your device
                and <strong>never</strong> sell, share, or track personal information.
              </p>
            </div>

            <div className="grid gap-5 md:grid-cols-3 mt-10">
              <div className="rounded-2xl border-2 border-[var(--vibrant-mint)] bg-green-50 p-6">
                <div className="text-3xl mb-3">📱</div>
                <p className="text-sm font-bold text-slate-900 mb-2">Data Collection</p>
                <p className="text-sm text-slate-700 leading-relaxed">
                  We do not collect personal information. Progress and profiles stay on your device only.
                </p>
              </div>
              <div className="rounded-2xl border-2 border-[var(--vibrant-sky-blue)] bg-blue-50 p-6">
                <div className="text-3xl mb-3">💳</div>
                <p className="text-sm font-bold text-slate-900 mb-2">Secure Purchases</p>
                <p className="text-sm text-slate-700 leading-relaxed">
                  Payments handled securely by Apple's StoreKit. We never see or store payment details.
                </p>
              </div>
              <div className="rounded-2xl border-2 border-[var(--vibrant-pink)] bg-pink-50 p-6">
                <div className="text-3xl mb-3">👶</div>
                <p className="text-sm font-bold text-slate-900 mb-2">Kids-First Design</p>
                <p className="text-sm text-slate-700 leading-relaxed">
                  No ads, no third-party tracking, and child-safe content designed for early readers.
                </p>
              </div>
            </div>
          </div>
        </section>

        {/* Privacy Policy Details */}
        <section className="rounded-3xl border border-white/50 bg-white/95 p-8 shadow-xl backdrop-blur md:p-12">
          <div className="space-y-8 max-w-4xl mx-auto">
            <div>
              <h3 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900 mb-4">
                Privacy Policy Summary
              </h3>
              <ul className="space-y-4 text-base text-slate-700 leading-relaxed">
                <li className="flex gap-3">
                  <span className="text-xl flex-shrink-0">✓</span>
                  <span>We store progress, profiles, and preferences <strong>locally on your device</strong>. You stay in control. Deleting the app removes all data.</span>
                </li>
                <li className="flex gap-3">
                  <span className="text-xl flex-shrink-0">✓</span>
                  <span>We use StoreKit for in-app purchases. Apple manages payment processing and receipts securely.</span>
                </li>
                <li className="flex gap-3">
                  <span className="text-xl flex-shrink-0">✓</span>
                  <span>We do <strong>not</strong> collect analytics, location data, advertising identifiers, or browsing history.</span>
                </li>
                <li className="flex gap-3">
                  <span className="text-xl flex-shrink-0">✓</span>
                  <span>
                    For questions or data requests, contact{" "}
                    <a
                      className="font-semibold text-[var(--vibrant-lavender)] underline decoration-2 underline-offset-2 hover:text-[var(--vibrant-pink)] transition"
                      href="mailto:support@earlyreader.app"
                    >
                      support@earlyreader.app
                    </a>
                  </span>
                </li>
              </ul>
            </div>

            <div className="border-t border-slate-200 pt-8">
              <h3 className="font-[family-name:var(--font-geist-mono)] text-xl font-bold text-slate-900 mb-4">
                What Information We Collect
              </h3>
              <div className="space-y-3 text-slate-700">
                <p className="leading-relaxed">
                  <strong>Local Data Only:</strong> Early Reader Phonics stores all user data locally on your device, including:
                </p>
                <ul className="list-disc list-inside space-y-2 ml-4">
                  <li>Child profiles (names and avatars you create)</li>
                  <li>Learning progress (words mastered and session history)</li>
                  <li>App settings and preferences</li>
                </ul>
                <p className="leading-relaxed">
                  This data never leaves your device and is not transmitted to our servers or any third party.
                </p>
              </div>
            </div>

            <div className="border-t border-slate-200 pt-8">
              <h3 className="font-[family-name:var(--font-geist-mono)] text-xl font-bold text-slate-900 mb-4">
                In-App Purchases
              </h3>
              <p className="text-slate-700 leading-relaxed">
                Premium features are available through Apple's In-App Purchase system. All payment processing is handled
                securely by Apple. We do not collect, store, or have access to your payment information. Purchase receipts
                are validated through Apple's servers to verify your premium status.
              </p>
            </div>

            <div className="border-t border-slate-200 pt-8">
              <h3 className="font-[family-name:var(--font-geist-mono)] text-xl font-bold text-slate-900 mb-4">
                Children's Privacy
              </h3>
              <p className="text-slate-700 leading-relaxed">
                Early Reader Phonics is designed for children ages 4-8. We are committed to protecting children's privacy
                and comply with applicable privacy laws including COPPA (Children's Online Privacy Protection Act). We do
                not knowingly collect any personal information from children. All data stays on the device and under parental control.
              </p>
            </div>

            <div className="border-t border-slate-200 pt-8">
              <h3 className="font-[family-name:var(--font-geist-mono)] text-xl font-bold text-slate-900 mb-4">
                Third-Party Services
              </h3>
              <p className="text-slate-700 leading-relaxed">
                We do not use any third-party analytics, advertising, or tracking services. The only third-party service
                we integrate with is Apple's StoreKit for in-app purchases, which is subject to Apple's privacy policy.
              </p>
            </div>

            <div className="border-t border-slate-200 pt-8">
              <h3 className="font-[family-name:var(--font-geist-mono)] text-xl font-bold text-slate-900 mb-4">
                Data Security
              </h3>
              <p className="text-slate-700 leading-relaxed">
                All user data is stored locally on your device using iOS's secure storage mechanisms. Since data never
                leaves your device, it is protected by your device's security features including encryption and biometric
                authentication (if enabled).
              </p>
            </div>

            <div className="border-t border-slate-200 pt-8">
              <h3 className="font-[family-name:var(--font-geist-mono)] text-xl font-bold text-slate-900 mb-4">
                Your Rights
              </h3>
              <p className="text-slate-700 leading-relaxed mb-3">
                Because all data is stored locally on your device, you have complete control:
              </p>
              <ul className="list-disc list-inside space-y-2 ml-4 text-slate-700">
                <li>Access your data at any time through the app</li>
                <li>Delete individual profiles or reset progress within the app</li>
                <li>Remove all data by deleting the app from your device</li>
              </ul>
            </div>

            <div className="border-t border-slate-200 pt-8">
              <h3 className="font-[family-name:var(--font-geist-mono)] text-xl font-bold text-slate-900 mb-4">
                Changes to This Policy
              </h3>
              <p className="text-slate-700 leading-relaxed">
                We may update this privacy policy from time to time. Any changes will be posted on this page with an
                updated revision date. We encourage you to review this policy periodically.
              </p>
            </div>

            <div className="border-t border-slate-200 pt-8">
              <h3 className="font-[family-name:var(--font-geist-mono)] text-xl font-bold text-slate-900 mb-4">
                Contact Us
              </h3>
              <p className="text-slate-700 leading-relaxed">
                If you have questions about this privacy policy or our practices, please contact us at{" "}
                <a
                  className="font-semibold text-[var(--vibrant-lavender)] underline decoration-2 underline-offset-2 hover:text-[var(--vibrant-pink)] transition"
                  href="mailto:support@earlyreader.app"
                >
                  support@earlyreader.app
                </a>
              </p>
            </div>

            <div className="border-t border-slate-200 pt-8">
              <p className="text-sm text-slate-500 text-center">
                Last updated: {new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })}
              </p>
            </div>
          </div>
        </section>

        {/* Footer */}
        <footer className="text-center text-sm text-slate-600 pt-8 border-t border-slate-200">
          <div className="flex flex-wrap gap-4 justify-center mb-4">
            <Link href="/" className="text-[var(--vibrant-lavender)] hover:underline font-medium">
              Home
            </Link>
            <Link href="/support" className="text-[var(--vibrant-lavender)] hover:underline font-medium">
              Support & FAQ
            </Link>
            <a href="mailto:support@earlyreader.app" className="text-[var(--vibrant-lavender)] hover:underline font-medium">
              Contact Us
            </a>
          </div>
          <p className="mb-2">
            © {new Date().getFullYear()} Early Reader Phonics. Made with 💜 for young learners.
          </p>
        </footer>
      </main>

      {/* Scroll to Top Button */}
      {showScrollTop && (
        <a
          href="#"
          className="fixed bottom-8 right-8 z-50 flex h-14 w-14 items-center justify-center rounded-full bg-gradient-to-r from-[var(--vibrant-lavender)] to-[var(--vibrant-pink)] text-white shadow-2xl shadow-purple-500/30 transition-all duration-300 hover:scale-110 hover:shadow-purple-500/50 focus:outline-none focus:ring-4 focus:ring-purple-300 animate-in fade-in slide-in-from-bottom-4"
          aria-label="Scroll to top"
        >
          <svg
            className="h-6 w-6"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={2}
              d="M5 10l7-7m0 0l7 7m-7-7v18"
            />
          </svg>
        </a>
      )}
    </div>
  );
}
