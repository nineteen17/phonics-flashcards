'use client';

import Link from "next/link";
import Image from "next/image";
import { useEffect, useState } from "react";

const troubleshootingSteps = [
  {
    title: "Refresh phonics decks",
    detail: "On Home, pull to refresh, then restart the app to reload cards.",
  },
  {
    title: "Restore purchases",
    detail: "Settings → Purchases → Restore. Use the same Apple ID as your original purchase.",
  },
  {
    title: "Audio not playing",
    detail: "Check the mute switch and volume, reconnect headphones, then relaunch the app.",
  },
  {
    title: "Progress missing",
    detail: "Choose the correct profile on Home. Progress is stored locally; reinstalling clears it.",
  },
];

const faqItems = [
  {
    question: "What ages is this app designed for?",
    answer: "Early Reader Phonics is perfect for children ages 4-8 who are learning to read. It's great for preschool through early elementary.",
  },
  {
    question: "Do I need an internet connection?",
    answer: "No! Once downloaded, the app works completely offline. All content and progress is stored locally on your device.",
  },
  {
    question: "Can multiple children use the same app?",
    answer: "Absolutely! Create individual profiles for each child to track their unique progress and customize their learning experience.",
  },
  {
    question: "What's included in the premium version?",
    answer: "Premium unlocks all 9 phonics groups with hundreds of words and up to 5 profile creations.",
  },
  {
    question: "How do I reset a child's progress?",
    answer: "Go to Settings, select the profile, and tap 'Reset Progress'. This clears all completed cards for a fresh start.",
  },
  {
    question: "Is my data safe?",
    answer: "Yes! All progress and profiles are stored locally on your device. We don't collect, track, or share any data.",
  },
];

export default function Support() {
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
                  Support & Help
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
              Support & Help
            </h2>
            <p className="text-lg text-slate-600 max-w-2xl mx-auto">
              Get help with Early Reader Phonics. Browse FAQs, troubleshooting tips, or contact our support team.
            </p>
          </div>

          {/* Quick Stats */}
          <div className="grid gap-4 md:grid-cols-3 max-w-3xl mx-auto">
            <div className="rounded-2xl border border-slate-200 bg-white/80 backdrop-blur p-5 text-center shadow-sm">
              <p className="text-xs font-semibold uppercase tracking-wider text-purple-600">Response Time</p>
              <p className="mt-2 text-2xl font-bold text-slate-900">Under 24hrs</p>
              <p className="text-sm text-slate-600">Mon–Fri, 9am–5pm</p>
            </div>
            <div className="rounded-2xl border border-slate-200 bg-white/80 backdrop-blur p-5 text-center shadow-sm">
              <p className="text-xs font-semibold uppercase tracking-wider text-green-600">Support Email</p>
              <p className="mt-2 text-lg font-bold text-slate-900">support@</p>
              <p className="text-sm text-slate-600">earlyreader.app</p>
            </div>
            <div className="rounded-2xl border border-slate-200 bg-white/80 backdrop-blur p-5 text-center shadow-sm">
              <p className="text-xs font-semibold uppercase tracking-wider text-pink-600">Available</p>
              <p className="mt-2 text-2xl font-bold text-slate-900">24/7</p>
              <p className="text-sm text-slate-600">Self-service help</p>
            </div>
          </div>
        </section>

        {/* FAQ Section */}
        <section className="rounded-3xl border border-white/50 bg-gradient-to-br from-white/90 to-purple-50/50 p-8 shadow-xl backdrop-blur md:p-12">
          <div className="text-center mb-10">
            <p className="text-sm font-bold uppercase tracking-widest text-[var(--vibrant-mint)] mb-3">
              ❓ FAQ
            </p>
            <h2 className="font-[family-name:var(--font-geist-mono)] text-3xl font-bold text-slate-900 md:text-4xl">
              Frequently Asked Questions
            </h2>
            <p className="mt-3 text-lg text-slate-600 max-w-2xl mx-auto">
              Quick answers to common questions about Early Reader Phonics.
            </p>
          </div>

          <div className="grid gap-5 max-w-4xl mx-auto">
            {faqItems.map((item, index) => (
              <details
                key={index}
                className="group rounded-2xl border border-slate-200 bg-white p-6 shadow-sm transition hover:shadow-md"
              >
                <summary className="flex cursor-pointer items-center justify-between font-[family-name:var(--font-geist-mono)] text-lg font-semibold text-slate-900 list-none">
                  {item.question}
                  <span className="ml-4 text-2xl transition-transform group-open:rotate-45">
                    +
                  </span>
                </summary>
                <p className="mt-4 text-slate-600 leading-relaxed pl-1">
                  {item.answer}
                </p>
              </details>
            ))}
          </div>
        </section>

        {/* Contact Section */}
        <section
          id="contact"
          className="grid gap-8 rounded-3xl border border-white/50 bg-white/90 p-8 shadow-xl backdrop-blur md:grid-cols-[1.4fr,1fr] md:p-12"
        >
          <div className="space-y-6">
            <div>
              <p className="text-sm font-bold uppercase tracking-widest text-[var(--vibrant-coral)] mb-3">
                📬 Contact Us
              </p>
              <h2 className="font-[family-name:var(--font-geist-mono)] text-3xl font-bold text-slate-900 md:text-4xl mb-3">
                We're here to help!
              </h2>
              <p className="text-base text-slate-600 leading-relaxed">
                Have a question or need assistance? Tell us what's happening and we'll guide you through it.
                Including screenshots and steps to reproduce issues helps us resolve problems faster.
              </p>
            </div>

            <div className="grid gap-4 md:grid-cols-2">
              <div className="rounded-2xl bg-gradient-to-br from-[var(--vibrant-lavender)] to-[var(--vibrant-pink)] p-6 text-white shadow-lg">
                <p className="text-sm font-semibold opacity-90 mb-1">📧 Email</p>
                <a
                  className="text-xl font-bold text-white underline decoration-white/50 decoration-2 underline-offset-4 hover:decoration-white transition"
                  href="mailto:support@earlyreader.app"
                >
                  support@earlyreader.app
                </a>
                <p className="text-sm opacity-90 mt-2">Mon–Fri, 9am–5pm</p>
              </div>
              <div className="rounded-2xl border-2 border-[var(--vibrant-mint)] bg-green-50 p-6">
                <p className="text-sm font-semibold text-slate-900 mb-1">⏱️ Response Time</p>
                <p className="text-slate-700 leading-relaxed">
                  We typically reply within one business day. For urgent billing issues, include your App Store receipt.
                </p>
              </div>
            </div>

            <form
              action={`https://formsubmit.co/${process.env.NEXT_PUBLIC_FORMSUBMIT_ENDPOINT || 'support@earlyreader.app'}`}
              method="POST"
              className="space-y-5 rounded-2xl border-2 border-slate-200 bg-white p-6 shadow-sm"
            >
              {/* FormSubmit Configuration */}
              <input type="hidden" name="_subject" value="New Support Request - Early Reader Phonics" />
              <input type="hidden" name="_template" value="table" />
              <input type="hidden" name="_captcha" value="false" />
              <input type="hidden" name="_next" value={`${process.env.NEXT_PUBLIC_SITE_URL || 'https://earlyreader.app'}/support?submitted=true`} />

              <div className="grid gap-4 md:grid-cols-2">
                <label className="flex flex-col gap-2 text-sm font-semibold text-slate-800">
                  Name
                  <input
                    type="text"
                    name="name"
                    className="rounded-xl border-2 border-slate-200 px-4 py-3 text-base text-slate-900 outline-none transition focus:border-[var(--vibrant-lavender)] focus:ring-4 focus:ring-purple-100"
                    required
                  />
                </label>
                <label className="flex flex-col gap-2 text-sm font-semibold text-slate-800">
                  Email
                  <input
                    type="email"
                    name="email"
                    className="rounded-xl border-2 border-slate-200 px-4 py-3 text-base text-slate-900 outline-none transition focus:border-[var(--vibrant-lavender)] focus:ring-4 focus:ring-purple-100"
                    required
                  />
                </label>
              </div>
              <label className="flex flex-col gap-2 text-sm font-semibold text-slate-800">
                Topic
                <select
                  name="topic"
                  className="rounded-xl border-2 border-slate-200 px-4 py-3 text-base text-slate-900 outline-none transition focus:border-[var(--vibrant-lavender)] focus:ring-4 focus:ring-purple-100"
                  defaultValue="Technical Issue"
                >
                  <option>Technical Issue</option>
                  <option>Billing or Purchases</option>
                  <option>Feature Request</option>
                  <option>General Feedback</option>
                </select>
              </label>
              <label className="flex flex-col gap-2 text-sm font-semibold text-slate-800">
                Message
                <textarea
                  name="message"
                  rows={5}
                  className="rounded-xl border-2 border-slate-200 px-4 py-3 text-base text-slate-900 outline-none transition focus:border-[var(--vibrant-lavender)] focus:ring-4 focus:ring-purple-100"
                  placeholder="Describe your issue or question. Include device model and iOS version if relevant."
                  required
                />
              </label>
              <p className="text-xs text-slate-500">
                Your message will be sent securely to our support team. We typically respond within 24 hours.
              </p>
              <button
                type="submit"
                className="inline-flex w-full items-center justify-center gap-2 rounded-2xl bg-gradient-to-r from-[var(--vibrant-lavender)] via-[var(--vibrant-pink)] to-[var(--vibrant-coral)] px-6 py-4 text-base font-bold text-white shadow-xl shadow-purple-300 transition hover:scale-[1.02] hover:shadow-2xl md:w-auto"
              >
                Send Message
                <span className="text-xl">→</span>
              </button>
            </form>
          </div>

          {/* Troubleshooting sidebar */}
          <div className="space-y-6 rounded-2xl border-2 border-slate-200 bg-gradient-to-br from-slate-50 to-blue-50 p-6 shadow-inner">
            <div>
              <p className="text-sm font-bold uppercase tracking-widest text-[var(--vibrant-sky-blue)] mb-2">
                🔧 Quick Fixes
              </p>
              <h3 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900 mb-2">
                Try these first
              </h3>
              <p className="text-sm text-slate-600">
                Common solutions that fix most issues instantly—no waiting needed.
              </p>
            </div>
            <div className="space-y-3">
              {troubleshootingSteps.map((step, index) => (
                <div
                  key={index}
                  className="rounded-xl bg-white border border-slate-200 px-4 py-4 shadow-sm hover:shadow-md transition"
                >
                  <p className="text-sm font-bold text-slate-900 mb-1 flex items-center gap-2">
                    <span className="flex items-center justify-center w-6 h-6 rounded-full bg-[var(--vibrant-sky-blue)] text-white text-xs font-bold">
                      {index + 1}
                    </span>
                    {step.title}
                  </p>
                  <p className="text-sm text-slate-600 pl-8">{step.detail}</p>
                </div>
              ))}
            </div>
            <div className="rounded-xl border-2 border-[var(--vibrant-peach)] bg-orange-50 px-4 py-4 text-sm text-slate-700">
              <strong>Still stuck?</strong> Email{" "}
              <a
                className="font-semibold text-[var(--vibrant-coral)] underline decoration-2 underline-offset-2 hover:text-[var(--vibrant-peach)] transition"
                href="mailto:support@earlyreader.app"
              >
                support@earlyreader.app
              </a>{" "}
              with screenshots if possible.
            </div>
          </div>
        </section>

        {/* Footer */}
        <footer className="text-center text-sm text-slate-600 pt-8 border-t border-slate-200">
          <div className="flex flex-wrap gap-4 justify-center mb-4">
            <Link href="/" className="text-[var(--vibrant-lavender)] hover:underline font-medium">
              Home
            </Link>
            <Link href="/privacy" className="text-[var(--vibrant-lavender)] hover:underline font-medium">
              Privacy Policy
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
