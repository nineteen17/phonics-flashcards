export default function Loading() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-pink-50 via-purple-50 to-blue-50 flex items-center justify-center">
      <div className="text-center">
        {/* Animated Logo Spinner */}
        <div className="relative w-24 h-24 mx-auto mb-6">
          <div className="absolute inset-0 rounded-full border-4 border-[var(--vibrant-lavender)]/20"></div>
          <div className="absolute inset-0 rounded-full border-4 border-transparent border-t-[var(--vibrant-lavender)] animate-spin"></div>
          <div className="absolute inset-3 rounded-full bg-gradient-to-br from-[var(--vibrant-lavender)] to-[var(--vibrant-pink)] flex items-center justify-center text-3xl">
            📚
          </div>
        </div>

        {/* Loading Text */}
        <p className="font-[family-name:var(--font-geist-mono)] text-lg font-semibold text-slate-900">
          Loading...
        </p>
        <p className="text-sm text-slate-600 mt-2">
          Getting things ready for you
        </p>
      </div>
    </div>
  );
}
