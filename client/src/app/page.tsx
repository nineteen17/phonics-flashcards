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
    description: "Pay once, own forever. No subscriptions!",
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

export default function Home() {
  const [showScrollTop, setShowScrollTop] = useState(false);
  const [isHeaderSticky, setIsHeaderSticky] = useState(false);
  const [pricing, setPricing] = useState<PricingData>(getLocalizedPricing("US"));
  const [selectedCountryCode, setSelectedCountryCode] = useState<string>("US");
  const [showCountryPicker, setShowCountryPicker] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [hideScrollButton, setHideScrollButton] = useState(false);
  const pickerRef = useRef<HTMLDivElement>(null);
  const heroRef = useRef<HTMLDivElement>(null);
  const scrollTimeoutRef = useRef<NodeJS.Timeout | null>(null);
  const [isClient, setIsClient] = useState(false);

  const allCountries = getAllCountries();
  const filteredCountries = allCountries.filter(({ data }) =>
    data.country.toLowerCase().includes(searchQuery.toLowerCase()) ||
    data.currencyCode.toLowerCase().includes(searchQuery.toLowerCase())
  );

  useEffect(() => {
    const handleScroll = () => {
      setShowScrollTop(window.scrollY > 400);
      setHideScrollButton(false);

      // Clear existing timeout
      if (scrollTimeoutRef.current) {
        clearTimeout(scrollTimeoutRef.current);
      }

      // Set new timeout to hide button after 2.5 seconds of inactivity
      scrollTimeoutRef.current = setTimeout(() => {
        setHideScrollButton(true);
      }, 2500);

      // Check if we've scrolled past the hero section
      if (heroRef.current) {
        const heroBottom = heroRef.current.offsetTop + heroRef.current.offsetHeight;
        setIsHeaderSticky(window.scrollY > heroBottom - 100);
      }
    };

    window.addEventListener('scroll', handleScroll);
    return () => {
      window.removeEventListener('scroll', handleScroll);
      if (scrollTimeoutRef.current) {
        clearTimeout(scrollTimeoutRef.current);
      }
    };
  }, []);

  useEffect(() => {
    setIsClient(true);
    const savedCountry = localStorage.getItem('selectedCountry');
    if (savedCountry && savedCountry !== 'US') {
      setSelectedCountryCode(savedCountry);
      setPricing(getLocalizedPricing(savedCountry));
    }
  }, []);

  useEffect(() => {
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

      {/* Sticky Header - shows when scrolled */}
      <header
        className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
          isHeaderSticky
            ? 'translate-y-0 opacity-100'
            : '-translate-y-full opacity-0'
        } border-b border-white/50 bg-white/95 backdrop-blur-lg shadow-lg`}
      >
        <div className="mx-auto max-w-none xl:max-w-[90vw] 2xl:max-w-[1600px] px-6 py-3 md:px-10 lg:px-16 xl:px-20">
          <div className="flex items-center justify-between gap-4">
            <div className="flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-white p-1.5 ring-2 ring-slate-200 shadow-md">
                <Image
                  src="/note-early-icon-logo-white.png"
                  alt="Early Reader Phonics"
                  width={40}
                  height={40}
                  className="w-full h-full object-contain"
                />
              </div>
              <h1 className="hidden md:block font-[family-name:var(--font-geist-mono)] text-lg font-bold text-slate-900">
                Early Reader Phonics
              </h1>
            </div>
            <div className="flex items-center gap-3">
              <a
                href={process.env.NEXT_PUBLIC_APP_STORE_URL || "https://apps.apple.com"}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center justify-center gap-2 rounded-xl bg-slate-900 px-4 py-2.5 text-sm font-bold text-white shadow-lg transition hover:scale-105"
              >
                <span className="text-lg">📱</span>
                <span className="hidden sm:inline">App Store</span>
              </a>
              <Link
                href="/support"
                className="inline-flex items-center justify-center gap-2 rounded-xl bg-white px-4 py-2.5 text-sm font-semibold text-slate-900 ring-2 ring-slate-200 transition hover:bg-slate-50"
              >
                <span className="text-base">💬</span>
                <span className="hidden sm:inline">Support</span>
              </Link>
            </div>
          </div>
        </div>
      </header>

      <main className="relative mx-auto flex w-full max-w-none xl:max-w-[90vw] 2xl:max-w-[1600px] flex-col gap-16 px-0 md:px-6 pb-20 pt-0 md:pt-12 lg:px-10 xl:px-16 lg:pt-16">
        {/* Hero Header */}
        <header ref={heroRef} className="overflow-hidden md:rounded-3xl md:border md:border-white/40 bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 px-6 py-10 md:shadow-2xl md:shadow-slate-900/20 md:backdrop-blur md:px-12 md:py-14">
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
                  Making reading fun and accessible for young learners ages 4-8.
                </p>
              </div>

              {/* Action buttons */}
              <div className="flex flex-wrap gap-4 justify-center pt-4">
                <a
                  href={process.env.NEXT_PUBLIC_APP_STORE_URL || "https://apps.apple.com"}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center justify-center gap-2 rounded-2xl bg-white px-8 py-5 text-lg font-bold text-slate-900 shadow-2xl shadow-white/20 transition hover:scale-105 hover:shadow-white/30"
                >
                  <span className="text-2xl">📱</span>
                  Download on App Store
                </a>
                <Link
                  href="/support"
                  className="inline-flex items-center justify-center gap-2 rounded-2xl bg-white/10 px-8 py-5 text-lg font-semibold text-white ring-2 ring-white/30 backdrop-blur transition hover:bg-white/20"
                >
                  <span className="text-xl">💬</span>
                  Get Support
                </Link>
              </div>
            </div>

            {/* Quick stats */}
            <div className="mt-10 grid gap-4 md:grid-cols-3 max-w-3xl mx-auto">
              <div className="rounded-2xl bg-white/10 p-5 text-center ring-1 ring-white/20 backdrop-blur">
                <p className="text-xs font-semibold uppercase tracking-wider text-green-200">Free Content</p>
                <p className="mt-2 text-2xl font-bold text-white">58 Cards</p>
                <p className="text-sm text-slate-300">50% free forever</p>
              </div>
              <div className="rounded-2xl bg-white/10 p-5 text-center ring-1 ring-white/20 backdrop-blur">
                <p className="text-xs font-semibold uppercase tracking-wider text-purple-200">Age Range</p>
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
        <section className="mx-6 md:mx-0 rounded-3xl border border-white/50 bg-white/80 p-8 shadow-xl backdrop-blur md:p-12">
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
        <section className="mx-6 md:mx-0 rounded-3xl border border-white/50 bg-gradient-to-br from-white/95 to-purple-50/50 p-8 shadow-xl backdrop-blur md:p-12">
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

          <div className="max-w-5xl mx-auto">
            <div className="grid md:grid-cols-2 gap-6">
              {/* Free Option */}
              <div className="rounded-3xl border-2 border-green-500 bg-gradient-to-br from-green-50 to-emerald-50 p-8 relative overflow-hidden shadow-xl">
                <div className="absolute top-3 right-3 md:top-4 md:right-4 rounded-full bg-green-500 px-2.5 py-1 md:px-4 md:py-1.5 text-[10px] md:text-xs font-bold text-white shadow-lg">
                  FREE FOREVER
                </div>
                <div className="space-y-4">
                  <div>
                    <h3 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900 mb-2">
                      Start Learning Free
                    </h3>
                    <p className="text-slate-700">
                      No credit card required. Download and start learning today!
                    </p>
                  </div>

                  <div className="py-4">
                    <div className="flex items-baseline gap-2 mb-2">
                      <span className="text-5xl font-bold text-green-600">58</span>
                      <span className="text-2xl text-slate-600">/ 116</span>
                    </div>
                    <p className="text-sm font-semibold text-slate-700">
                      cards included (50% of all content)
                    </p>
                    <p className="text-sm text-slate-600 mt-1">
                      Over 450 free words
                    </p>
                  </div>

                  <div className="space-y-2">
                    <div className="flex items-center gap-2 text-sm text-slate-700">
                      <svg className="w-5 h-5 text-green-600 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                      </svg>
                      <span>All 9 phonics groups accessible</span>
                    </div>
                    <div className="flex items-center gap-2 text-sm text-slate-700">
                      <svg className="w-5 h-5 text-green-600 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                      </svg>
                      <span>1 profile for tracking progress</span>
                    </div>
                    <div className="flex items-center gap-2 text-sm text-slate-700">
                      <svg className="w-5 h-5 text-green-600 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                      </svg>
                      <span>Full offline access</span>
                    </div>
                    <div className="flex items-center gap-2 text-sm text-slate-700">
                      <svg className="w-5 h-5 text-green-600 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                      </svg>
                      <span>No ads, no tracking, no data collection</span>
                    </div>
                  </div>

                  <a
                    href={process.env.NEXT_PUBLIC_APP_STORE_URL || "https://apps.apple.com"}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="mt-4 inline-flex w-full items-center justify-center gap-2 rounded-2xl bg-green-600 px-6 py-4 text-base font-bold text-white shadow-xl shadow-green-300 transition hover:scale-105 hover:bg-green-700"
                  >
                    <span className="text-2xl">📱</span>
                    Download Free Now
                  </a>
                </div>
              </div>

              {/* Premium Option with Country Picker */}
              <div className="rounded-3xl border-2 border-[var(--vibrant-lavender)] bg-gradient-to-br from-purple-50 to-pink-50 p-8 shadow-xl relative">
                <div className="space-y-4">
                  <div>
                    <h3 className="font-[family-name:var(--font-geist-mono)] text-2xl font-bold text-slate-900 mb-2">
                      Unlock Everything
                    </h3>
                    <p className="text-slate-700">
                      Get full access to all 9 phonics groups
                    </p>
                  </div>

                  <div className="py-4">
                    <div className="flex items-baseline gap-2 mb-2">
                      <span className="text-5xl font-bold bg-gradient-to-r from-[var(--vibrant-lavender)] to-[var(--vibrant-pink)] bg-clip-text text-transparent">
                        {formatPrice(pricing)}
                      </span>
                      <span className="text-lg text-slate-600">{pricing.currencyCode}</span>
                    </div>
                    <p className="text-sm font-semibold text-slate-700">
                      One-time purchase, yours forever
                    </p>
                  </div>

                  {/* Country Picker */}
                  <div className="relative" ref={pickerRef}>
                    <button
                      onClick={() => setShowCountryPicker(!showCountryPicker)}
                      className="w-full flex items-center justify-between gap-3 px-4 py-3 bg-white border-2 border-slate-200 rounded-xl hover:bg-slate-50 hover:border-[var(--vibrant-lavender)] transition-all group"
                    >
                      <div className="flex items-center gap-2">
                        <span className="text-xl">{pricing.flag}</span>
                        <div className="text-left">
                          <p className="text-xs font-semibold text-slate-900">
                            {pricing.country}
                          </p>
                          <p className="text-xs text-slate-500">
                            {pricing.currencyCode} pricing
                          </p>
                        </div>
                      </div>
                      <svg
                        className={`w-4 h-4 text-slate-400 group-hover:text-[var(--vibrant-lavender)] transition-transform ${
                          showCountryPicker ? "rotate-180" : ""
                        }`}
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                      </svg>
                    </button>

                    {showCountryPicker && (
                      <div className="absolute top-full mt-2 left-0 right-0 bg-white rounded-xl border-2 border-slate-200 shadow-2xl z-50 max-h-80 overflow-hidden flex flex-col">
                        <div className="p-3 border-b border-slate-200">
                          <input
                            type="text"
                            placeholder="Search country or currency..."
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                            className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[var(--vibrant-lavender)] focus:border-transparent"
                            autoFocus
                          />
                        </div>
                        <div className="overflow-y-auto">
                          {filteredCountries.map(({ code, data }) => (
                            <button
                              key={code}
                              onClick={() => handleCountrySelect(code)}
                              className={`w-full flex items-center gap-3 px-5 py-3 hover:bg-purple-50 transition text-left ${
                                selectedCountryCode === code ? "bg-purple-50" : ""
                              }`}
                            >
                              <span className="text-2xl">{data.flag}</span>
                              <div className="flex-1 min-w-0">
                                <p className="text-sm font-semibold text-slate-900 truncate">
                                  {data.country}
                                </p>
                                <p className="text-xs text-slate-500">
                                  {formatPrice(data)} {data.currencyCode}
                                </p>
                              </div>
                              {selectedCountryCode === code && (
                                <svg className="w-5 h-5 text-[var(--vibrant-lavender)] flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                                  <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                                </svg>
                              )}
                            </button>
                          ))}
                        </div>
                      </div>
                    )}
                  </div>

                  <div className="space-y-2">
                    <div className="flex items-center gap-2 text-sm text-slate-700">
                      <svg className="w-5 h-5 text-purple-600 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                      </svg>
                      <span><strong>All 116 cards</strong> • Over 900 words</span>
                    </div>
                    <div className="flex items-center gap-2 text-sm text-slate-700">
                      <svg className="w-5 h-5 text-purple-600 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                      </svg>
                      <span>Up to 5 profiles (perfect for families)</span>
                    </div>
                    <div className="flex items-center gap-2 text-sm text-slate-700">
                      <svg className="w-5 h-5 text-purple-600 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                      </svg>
                      <span>Restore on any device with same Apple ID</span>
                    </div>
                    <div className="flex items-center gap-2 text-sm text-slate-700">
                      <svg className="w-5 h-5 text-purple-600 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                      </svg>
                      <span>Upgrade anytime in-app</span>
                    </div>
                  </div>

                  <p className="text-xs text-slate-500 pt-4 border-t border-slate-200">
                    Try the free version first, upgrade when you're ready. No pressure!
                  </p>
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Screenshot Gallery Section */}
        <section className="mx-6 md:mx-0 rounded-3xl border border-white/50 bg-gradient-to-br from-white/95 to-pink-50/50 p-8 shadow-xl backdrop-blur md:p-12">
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
        </section>

        {/* Footer */}
        <footer className="mx-6 md:mx-0 text-center text-sm text-slate-600 pt-8 border-t border-slate-200">
          <div className="flex flex-wrap gap-4 justify-center mb-4">
            <Link href="/support" className="text-[var(--vibrant-lavender)] hover:underline font-medium">
              Support & FAQ
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
      {showScrollTop && !hideScrollButton && (
        <a
          href="#"
          className="fixed bottom-8 right-8 z-50 flex h-14 w-14 items-center justify-center rounded-full bg-gradient-to-r from-[var(--vibrant-lavender)] to-[var(--vibrant-pink)] text-white shadow-2xl shadow-purple-500/30 transition-all duration-300 hover:scale-110 hover:shadow-purple-500/50 focus:outline-none focus:ring-4 focus:ring-purple-300 animate-in fade-in slide-in-from-bottom-4"
          aria-label="Scroll to top"
          onMouseEnter={() => {
            setHideScrollButton(false);
            if (scrollTimeoutRef.current) {
              clearTimeout(scrollTimeoutRef.current);
            }
          }}
          onMouseLeave={() => {
            scrollTimeoutRef.current = setTimeout(() => {
              setHideScrollButton(true);
            }, 2500);
          }}
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
