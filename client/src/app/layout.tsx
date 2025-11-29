import type { Metadata } from "next";
import { Inter, Fredoka } from "next/font/google";
import "./globals.css";

const inter = Inter({
  variable: "--font-geist-sans",
  subsets: ["latin"],
  display: "swap",
});

const fredoka = Fredoka({
  variable: "--font-geist-mono",
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
  display: "swap",
});

export const metadata: Metadata = {
  metadataBase: new URL(process.env.NEXT_PUBLIC_SITE_URL || 'https://earlyreader.app'),
  title: {
    default: "Early Reader Phonics - Help & Support",
    template: "%s | Early Reader Phonics",
  },
  description:
    "Help center for Early Reader Phonics. Get support, view troubleshooting tips, contact us, and review our privacy policy. Perfect for ages 4-8 learning to read.",
  keywords: [
    "phonics",
    "early reader",
    "kids learning",
    "reading app",
    "educational app",
    "children phonics",
    "flashcards",
    "learning to read",
  ],
  authors: [{ name: "Early Reader Phonics" }],
  creator: "Early Reader Phonics",
  publisher: "Early Reader Phonics",
  openGraph: {
    type: "website",
    locale: "en_US",
    url: "/",
    title: "Early Reader Phonics - Help & Support",
    description:
      "Help center for Early Reader Phonics. Perfect for ages 4-8 learning to read with engaging flashcards and progress tracking.",
    siteName: "Early Reader Phonics",
    images: [
      {
        url: "/og-image.png",
        width: 1200,
        height: 630,
        alt: "Early Reader Phonics - Learn to Read with Fun Flashcards",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "Early Reader Phonics - Help & Support",
    description:
      "Help center for Early Reader Phonics. Perfect for ages 4-8 learning to read.",
    images: ["/og-image.png"],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-video-preview": -1,
      "max-image-preview": "large",
      "max-snippet": -1,
    },
  },
  icons: {
    icon: [
      { url: "/favicon.ico", sizes: "any" },
      { url: "/favicon-16x16.png", type: "image/png", sizes: "16x16" },
      { url: "/favicon-32x32.png", type: "image/png", sizes: "32x32" },
    ],
    apple: [{ url: "/apple-touch-icon.png", sizes: "180x180" }],
  },
  manifest: "/manifest.json",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="scroll-smooth">
      <body
        className={`${inter.variable} ${fredoka.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
