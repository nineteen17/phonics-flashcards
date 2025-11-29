import Link from "next/link";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Page Not Found",
  description: "The page you're looking for doesn't exist.",
};

export default function NotFound() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-pink-50 via-purple-50 to-blue-50 flex items-center justify-center px-6">
      <div className="max-w-2xl w-full text-center">
        <div className="rounded-3xl border border-white/50 bg-white/90 p-12 shadow-2xl backdrop-blur">
          {/* 404 Icon */}
          <div className="text-8xl mb-6">🔍</div>

          {/* Error Code */}
          <h1 className="font-[family-name:var(--font-geist-mono)] text-7xl font-bold text-[var(--vibrant-lavender)] mb-4">
            404
          </h1>

          {/* Message */}
          <h2 className="font-[family-name:var(--font-geist-mono)] text-3xl font-bold text-slate-900 mb-4">
            Page Not Found
          </h2>

          <p className="text-lg text-slate-600 mb-8 leading-relaxed">
            Oops! The page you're looking for seems to have wandered off.
            Let's get you back on track.
          </p>

          {/* Action Buttons */}
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link
              href="/"
              className="inline-flex items-center justify-center gap-2 rounded-2xl bg-gradient-to-r from-[var(--vibrant-lavender)] to-[var(--vibrant-pink)] px-8 py-4 text-base font-bold text-white shadow-xl shadow-purple-300 transition hover:scale-105"
            >
              <span className="text-xl">🏠</span>
              Go Home
            </Link>

            <a
              href="mailto:support@earlyreader.app"
              className="inline-flex items-center justify-center gap-2 rounded-2xl border-2 border-slate-200 bg-white px-8 py-4 text-base font-semibold text-slate-900 transition hover:border-[var(--vibrant-lavender)] hover:shadow-lg"
            >
              <span className="text-xl">📧</span>
              Contact Support
            </a>
          </div>

          {/* Helpful Links */}
          <div className="mt-10 pt-8 border-t border-slate-200">
            <p className="text-sm font-semibold text-slate-700 mb-4">
              Looking for something specific?
            </p>
            <div className="flex flex-wrap gap-3 justify-center text-sm">
              <Link
                href="/#contact"
                className="text-[var(--vibrant-lavender)] hover:underline font-medium"
              >
                Contact Us
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
                href="/terms"
                className="text-[var(--vibrant-lavender)] hover:underline font-medium"
              >
                Terms of Service
              </Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
