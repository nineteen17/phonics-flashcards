'use client';

import Image from "next/image";
import Link from "next/link";
import { useEffect, useState, useRef } from "react";
import { getLocalizedPricing, formatPrice, getAllCountries, type PricingData } from "@/data/pricing";

const features = [
  {
    icon: "🎯",
    title: "Phonics Mastery",
    description: "9 comprehensive groups covering short vowels, blends, digraphs, and more",
  },
  {
    icon: "🎨",
    title: "Vibrant Cards",
    description: "Colorful, engaging flashcards designed for young learners",
  },
  {
    icon: "👥",
    title: "Multi-Profile",
    description: "Track progress for multiple children with individual profiles",
  },
  {
    icon: "💵",
    title: "One-Time Purchase",
    description: "Pay once, own forever, No subscriptions!",
  },
  {
    icon: "📊",
    title: "Progress Tracking",
    description: "See words mastered and sessions completed",
  },
  {
    icon: "↓",
    title: "Offline Access",
    description: "No internet required, no external tracking, no ads",
  },
];

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

export default function Home() {
  const [showScrollTop, setShowScrollTop] = useState(false);
  const [pricing, setPricing] = useState<PricingData | null>(null);
  const [selectedCountryCode, setSelectedCountryCode] = useState<string>("US");
  const [showCountryPicker, setShowCountryPicker] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const pickerRef = useRef<HTMLDivElement>(null);

  const allCountries = getAllCountries();
  const filteredCountries = allCountries.filter(({ data }) =>
    data.country.toLowerCase().includes(searchQuery.toLowerCase()) ||
    data.currencyCode.toLowerCase().includes(searchQuery.toLowerCase())
  );

  useEffect(() => {
    const handleScroll = () => {
      setShowScrollTop(window.scrollY > 400);
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  useEffect(() => {
    // Load saved country from localStorage or default to US
    const savedCountry = localStorage.getItem('selectedCountry');
    const countryCode = savedCountry || 'US';
    setSelectedCountryCode(countryCode);
    setPricing(getLocalizedPricing(countryCode));
  }, []);

  useEffect(() => {
    // Close picker when clicking outside
    const handleClickOutside = (event: MouseEvent) => {
      if (pickerRef.current && !pickerRef.current.contains(event.target as Node)) {
        setShowCountryPicker(false);
        setSearchQuery("");
      }
    };

    if (showCountryPicker) {
      document.addEventListener('mousedown', handleClickOutside);
    }
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, [showCountryPicker]);

  const handleCountrySelect = (countryCode: string) => {
    setSelectedCountryCode(countryCode);
    setPricing(getLocalizedPricing(countryCode));
    localStorage.setItem('selectedCountry', countryCode);
    setShowCountryPicker(false);
    setSearchQuery("");
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-pink-50 via-purple-50 to-blue-50 text-slate-900 scroll-smooth">
      {/* Decorative background elements */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-10 left-10 w-72 h-72 bg-[var(--vibrant-pink)] rounded-full opacity-10 blur-3xl" />
        <div className="absolute top-40 right-20 w-96 h-96 bg-[var(--vibrant-lavender)] rounded-full opacity-10 blur-3xl" />
        <div className="absolute bottom-20 left-1/3 w-80 h-80 bg-[var(--vibrant-mint)] rounded-full opacity-10 blur-3xl" />
      </div>

      <main className="relative mx-auto flex w-full max-w-none xl:max-w-[90vw] 2xl:max-w-[1600px] flex-col gap-16 px-6 pb-20 pt-12 md:px-10 lg:px-16 xl:px-20 lg:pt-16">
        {/* Hero Header */}
        <header className="overflow-hidden rounded-3xl border border-white/40 bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 px-6 py-10 shadow-2xl shadow-slate-900/20 backdrop-blur md:px-12 md:py-14">
          <div className="absolute inset-0 bg-[radial-gradient(circle_at_30%_20%,rgba(255,255,255,0.1),transparent_40%),radial-gradient(circle_at_70%_80%,rgba(179,77,242,0.15),transparent_50%)]" />

          <div className="relative">
            <div className="flex flex-col items-center text-center gap-6">
              {/* Logo */}
              <div className="flex h-32 w-32 items-center justify-center rounded-3xl bg-white p-2 ring-2 ring-white/20 shadow-xl">
                <Image
                  src="/note-early-icon-logo-white.png"
                  alt="Early Reader Phonics"
                  width={120}
                  height={120}
                  priority
                  className="w-full h-full object-contain"
                />
              </div>

              {/* Title */}
              <div className="space-y-3">
                <h1 className="font-[family-name:var(--font-geist-mono)] text-4xl font-bold leading-tight text-white md:text-6xl">
                  Early Reader Phonics
                </h1>
                <p className="text-lg text-slate-300 md:text-xl max-w-2xl mx-auto">
                  Making phonics fun and accessible for young learners. Get help, explore features, and connect with support.
                </p>
              </div>

              {/* Action buttons */}
              <div className="flex flex-wrap gap-4 justify-center pt-4">
                <a
                  href={process.env.NEXT_PUBLIC_APP_STORE_URL || "https://apps.apple.com"}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center justify-center gap-2 rounded-2xl bg-white px-6 py-4 text-base font-bold text-slate-900 shadow-2xl shadow-white/20 transition hover:scale-105 hover:shadow-white/30"
                >
                  <span className="text-2xl">📱</span>
                  Download on App Store
                </a>
                <a
                  href="mailto:support@earlyreader.app"
                  className="inline-flex items-center justify-center gap-2 rounded-2xl bg-white/10 px-6 py-4 text-base font-semibold text-white ring-2 ring-white/30 backdrop-blur transition hover:bg-white/20"
                >
                  <span className="text-xl">📧</span>
                  Email Support
                </a>
                <Link
                  href="#contact"
                  className="inline-flex items-center justify-center gap-2 rounded-2xl bg-[var(--vibrant-lavender)] px-6 py-4 text-base font-semibold text-white shadow-lg shadow-purple-500/25 transition hover:scale-105"
                >
                  Get Help
                </Link>
              </div>
            </div>

            {/* Quick stats */}
            <div className="mt-10 grid gap-4 md:grid-cols-3 max-w-3xl mx-auto">
              <div className="rounded-2xl bg-white/10 p-5 text-center ring-1 ring-white/20 backdrop-blur">
                <p className="text-xs font-semibold uppercase tracking-wider text-purple-200">Response Time</p>
                <p className="mt-2 text-2xl font-bold text-white">Under 24hrs</p>
                <p className="text-sm text-slate-300">Mon–Fri, 9am–5pm</p>
              </div>
              <div className="rounded-2xl bg-white/10 p-5 text-center ring-1 ring-white/20 backdrop-blur">
                <p className="text-xs font-semibold uppercase tracking-wider text-green-200">Age Range</p>
                <p className="mt-2 text-2xl font-bold text-white">Ages 4-8</p>
                <p className="text-sm text-slate-300">Perfect for early readers</p>
              </div>
              <div className="rounded-2xl bg-white/10 p-5 text-center ring-1 ring-white/20 backdrop-blur">
                <p className="text-xs font-semibold uppercase tracking-wider text-pink-200">Privacy</p>
                <p className="mt-2 text-2xl font-bold text-white">100% Local</p>
                <p className="text-sm text-slate-300">No tracking or ads</p>
              </div>
            </div>
          </div>
        </header>

        {/* Features Section */}
        <section className="rounded-3xl border border-white/50 bg-white/80 p-8 shadow-xl backdrop-blur md:p-12">
          <div className="text-center mb-10">
            <p className="text-sm font-bold uppercase tracking-widest text-[var(--vibrant-lavender)] mb-3">
              ✨ Features
            </p>
            <h2 className="font-[family-name:var(--font-geist-mono)] text-3xl font-bold text-slate-900 md:text-4xl">
              Everything your child needs to learn phonics
            </h2>
            <p className="mt-3 text-lg text-slate-600 max-w-2xl mx-auto">
              Carefully designed features that make learning to read engaging, effective, and fun.
            </p>
          </div>

          <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            {features.map((feature, index) => (
              <div
                key={index}
                className="group rounded-2xl border border-slate-200 bg-white p-6 shadow-sm transition hover:shadow-xl hover:scale-105 hover:border-[var(--vibrant-lavender)]"
              >
                <div className="text-4xl mb-4 group-hover:scale-110 transition-transform">
                  {feature.icon}
                </div>
                <h3 className="font-[family-name:var(--font-geist-mono)] text-xl font-bold text-slate-900 mb-2">
                  {feature.title}
                </h3>
                <p className="text-slate-600 leading-relaxed">
                  {feature.description}
                </p>
              </div>
            ))}
          </div>
        </section>

        {/* Pricing Section */}
        <section className="rounded-3xl border border-white/50 bg-gradient-to-br from-white/95 to-purple-50/50 p-8 shadow-xl backdrop-blur md:p-12">
          <div className="text-center mb-10">
            <p className="text-sm font-bold uppercase tracking-widest text-[var(--vibrant-coral)] mb-3">
              💰 Simple Pricing
            </p>
            <h2 className="font-[family-name:var(--font-geist-mono)] text-3xl font-bold text-slate-900 md:text-4xl">
              One-Time Purchase. Own Forever.
            </h2>
            <p className="mt-3 text-lg text-slate-600 max-w-2xl mx-auto">
              No subscriptions. No hidden fees. Pay once and unlock everything.
            </p>
          </div>

          <div className="max-w-4xl mx-auto">
            <div className="rounded-3xl border-2 border-[var(--vibrant-lavender)] bg-white p-8 md:p-12 shadow-2xl relative overflow-hidden">
              {/* Popular Badge */}


              <div className="text-center mb-8">
                <h3 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900 mb-2">
                  Premium Unlock
                </h3>
                <p className="text-slate-600">
                  Unlock all 9 phonics groups and unlimited profiles
                </p>
              </div>

              <div className="flex flex-col items-center justify-center gap-4 mb-8">
                {/* Localized Pricing */}
                <div className="text-center relative">
                  {pricing ? (
                    <>
                      <div className="flex items-center justify-center gap-2 mb-2">
                        <p className="text-sm font-semibold text-slate-600">{pricing.country}</p>
                        <button
                          onClick={() => setShowCountryPicker(!showCountryPicker)}
                          className="text-xs text-[var(--vibrant-lavender)] hover:text-[var(--vibrant-pink)] font-medium underline"
                        >
                          Change
                        </button>
                      </div>
                      <div className="flex items-baseline justify-center gap-2">
                        <span className="text-5xl font-bold bg-gradient-to-r from-[var(--vibrant-lavender)] to-[var(--vibrant-pink)] bg-clip-text text-transparent">
                          {formatPrice(pricing)}
                        </span>
                        <span className="text-lg text-slate-600">{pricing.currencyCode}</span>
                      </div>

                      {/* Country Picker Dropdown */}
                      {showCountryPicker && (
                        <div
                          ref={pickerRef}
                          className="absolute top-full mt-2 left-1/2 -translate-x-1/2 w-80 max-h-96 bg-white rounded-2xl shadow-2xl border-2 border-slate-200 z-50 overflow-hidden"
                        >
                          {/* Search Input */}
                          <div className="p-4 border-b border-slate-200 bg-slate-50">
                            <input
                              type="text"
                              placeholder="Search country or currency..."
                              value={searchQuery}
                              onChange={(e) => setSearchQuery(e.target.value)}
                              className="w-full px-4 py-2 rounded-lg border border-slate-300 focus:outline-none focus:ring-2 focus:ring-[var(--vibrant-lavender)] text-sm"
                              autoFocus
                            />
                          </div>

                          {/* Country List */}
                          <div className="max-h-80 overflow-y-auto">
                            {filteredCountries.length > 0 ? (
                              filteredCountries.map(({ code, data }) => (
                                <button
                                  key={code}
                                  onClick={() => handleCountrySelect(code)}
                                  className={`w-full px-4 py-3 text-left hover:bg-slate-50 transition flex items-center justify-between ${
                                    code === selectedCountryCode ? 'bg-purple-50 border-l-4 border-[var(--vibrant-lavender)]' : ''
                                  }`}
                                >
                                  <div className="flex-1">
                                    <p className="font-medium text-slate-900 text-sm">{data.country}</p>
                                    <p className="text-xs text-slate-500">{data.currencyCode}</p>
                                  </div>
                                  <p className="font-bold text-[var(--vibrant-lavender)] text-sm">
                                    {formatPrice(data)}
                                  </p>
                                </button>
                              ))
                            ) : (
                              <div className="p-8 text-center text-slate-500">
                                <p className="text-sm">No countries found</p>
                                <p className="text-xs mt-1">Try a different search term</p>
                              </div>
                            )}
                          </div>
                        </div>
                      )}
                    </>
                  ) : (
                    <div className="h-20 flex items-center justify-center">
                      <div className="animate-pulse flex flex-col items-center gap-2">
                        <div className="h-12 w-32 bg-slate-200 rounded"></div>
                        <div className="h-4 w-24 bg-slate-200 rounded"></div>
                      </div>
                    </div>
                  )}
                </div>
              </div>

              <div className="space-y-4 mb-8">
                <div className="flex items-start gap-3">
                  <div className="flex-shrink-0 w-6 h-6 rounded-full bg-green-100 flex items-center justify-center">
                    <svg className="w-4 h-4 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                  </div>
                  <div>
                    <p className="font-semibold text-slate-900">All 9 Phonics Groups</p>
                    <p className="text-sm text-slate-600">Short vowels, blends, digraphs, diphthongs, and more</p>
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <div className="flex-shrink-0 w-6 h-6 rounded-full bg-green-100 flex items-center justify-center">
                    <svg className="w-4 h-4 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                  </div>
                  <div>
                    <p className="font-semibold text-slate-900">Up to 5 Profiles</p>
                    <p className="text-sm text-slate-600">Track progress for multiple children individually</p>
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <div className="flex-shrink-0 w-6 h-6 rounded-full bg-green-100 flex items-center justify-center">
                    <svg className="w-4 h-4 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                  </div>
                  <div>
                    <p className="font-semibold text-slate-900">Lifetime Access</p>
                    <p className="text-sm text-slate-600">One-time purchase, no recurring fees</p>
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <div className="flex-shrink-0 w-6 h-6 rounded-full bg-green-100 flex items-center justify-center">
                    <svg className="w-4 h-4 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                  </div>
                  <div>
                    <p className="font-semibold text-slate-900">Restore on Any Device</p>
                    <p className="text-sm text-slate-600">Use the same Apple ID to restore your purchase</p>
                  </div>
                </div>
              </div>

              <div className="text-center">
                <a
                  href={process.env.NEXT_PUBLIC_APP_STORE_URL || "https://apps.apple.com"}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center justify-center gap-2 rounded-2xl bg-gradient-to-r from-[var(--vibrant-lavender)] via-[var(--vibrant-pink)] to-[var(--vibrant-coral)] px-10 py-5 text-lg font-bold text-white shadow-2xl shadow-purple-300 transition hover:scale-105 hover:shadow-purple-400"
                >
                  <span className="text-2xl">📱</span>
                  Download Now
                </a>
                <p className="text-xs text-slate-500 mt-4">
                  Pricing may vary by region. Displayed prices are approximate.
                </p>
              </div>
            </div>

            {/* Free Features */}
            <div className="mt-8 rounded-2xl border-2 border-slate-200 bg-slate-50 p-6 text-center">
              <p className="font-semibold text-slate-900 mb-2">Try Before You Buy</p>
              <p className="text-sm text-slate-600">
                Download free and try the first phonics group. Upgrade anytime to unlock all content.
              </p>
            </div>
          </div>
        </section>

        {/* Screenshot Gallery Section */}
        <section className="rounded-3xl border border-white/50 bg-gradient-to-br from-white/95 to-pink-50/50 p-8 shadow-xl backdrop-blur md:p-12">
          <div className="text-center mb-10">
            <p className="text-sm font-bold uppercase tracking-widest text-[var(--vibrant-pink)] mb-3">
              📸 See It In Action
            </p>
            <h2 className="font-[family-name:var(--font-geist-mono)] text-3xl font-bold text-slate-900 md:text-4xl">
              Beautiful, Engaging Learning Experience
            </h2>
            <p className="mt-3 text-lg text-slate-600 max-w-2xl mx-auto">
              Vibrant flashcards, intuitive swipe gestures, and personalized progress tracking for each child.
            </p>
          </div>

          <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            <div className="rounded-2xl overflow-hidden border-2 border-slate-200 bg-white shadow-lg hover:shadow-2xl transition hover:scale-105">
              <div className="aspect-[9/19.5] bg-gradient-to-br from-pink-100 to-purple-100 flex items-center justify-center">
                <div className="text-center p-8">
                  <div className="text-6xl mb-4">📚</div>
                  <p className="font-[family-name:var(--font-geist-mono)] text-lg font-bold text-slate-900">
                    Home Screen
                  </p>
                  <p className="text-sm text-slate-600 mt-2">
                    Choose from 9 phonics groups
                  </p>
                </div>
              </div>
            </div>

            <div className="rounded-2xl overflow-hidden border-2 border-slate-200 bg-white shadow-lg hover:shadow-2xl transition hover:scale-105">
              <div className="aspect-[9/19.5] bg-gradient-to-br from-purple-100 to-blue-100 flex items-center justify-center">
                <div className="text-center p-8">
                  <div className="text-6xl mb-4">👆</div>
                  <p className="font-[family-name:var(--font-geist-mono)] text-lg font-bold text-slate-900">
                    Swipe to Learn
                  </p>
                  <p className="text-sm text-slate-600 mt-2">
                    Interactive flashcard swiping
                  </p>
                </div>
              </div>
            </div>

            <div className="rounded-2xl overflow-hidden border-2 border-slate-200 bg-white shadow-lg hover:shadow-2xl transition hover:scale-105">
              <div className="aspect-[9/19.5] bg-gradient-to-br from-green-100 to-mint-100 flex items-center justify-center">
                <div className="text-center p-8">
                  <div className="text-6xl mb-4">📊</div>
                  <p className="font-[family-name:var(--font-geist-mono)] text-lg font-bold text-slate-900">
                    Track Progress
                  </p>
                  <p className="text-sm text-slate-600 mt-2">
                    See words mastered and sessions
                  </p>
                </div>
              </div>
            </div>
          </div>

          <div className="mt-8 text-center">
            <p className="text-sm text-slate-600 mb-4">
              Want to see real screenshots? Place your app screenshots in the <code className="bg-slate-100 px-2 py-1 rounded text-xs">/public/screenshots/</code> folder and they'll appear here.
            </p>
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
              <input type="hidden" name="_next" value={`${process.env.NEXT_PUBLIC_SITE_URL || 'https://earlyreader.app'}/?submitted=true`} />

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

        {/* Privacy Policy Section */}
        <section
          id="privacy-policy"
          className="rounded-3xl border border-white/50 bg-white/95 p-8 shadow-xl backdrop-blur md:p-12"
        >
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

            <div className="mt-8 space-y-4 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
              <h3 className="font-[family-name:var(--font-geist-mono)] text-xl font-bold text-slate-900">
                Privacy Policy Summary
              </h3>
              <ul className="space-y-3 text-sm text-slate-700 leading-relaxed">
                <li className="flex gap-3">
                  <span className="text-lg">✓</span>
                  <span>We store progress, profiles, and preferences <strong>locally on your device</strong>. You stay in control. Deleting the app removes all data.</span>
                </li>
                <li className="flex gap-3">
                  <span className="text-lg">✓</span>
                  <span>We use StoreKit for in-app purchases. Apple manages payment processing and receipts securely.</span>
                </li>
                <li className="flex gap-3">
                  <span className="text-lg">✓</span>
                  <span>We do <strong>not</strong> collect analytics, location data, advertising identifiers, or browsing history.</span>
                </li>
                <li className="flex gap-3">
                  <span className="text-lg">✓</span>
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
          </div>
        </section>

        {/* Footer */}
        <footer className="text-center text-sm text-slate-600 pt-8 border-t border-slate-200">
          <p className="mb-2">
            © {new Date().getFullYear()} Early Reader Phonics. Made with 💜 for young learners.
          </p>
          <p className="text-xs text-slate-500">
            Questions? Email{" "}
            <a
              href="mailto:support@earlyreader.app"
              className="text-[var(--vibrant-lavender)] hover:underline"
            >
              support@earlyreader.app
            </a>
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
