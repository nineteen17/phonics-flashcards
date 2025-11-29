# Early Reader Phonics - Support Website

Modern, responsive support website for the Early Reader Phonics iOS app built with Next.js 16 and Tailwind CSS 4.

## 🚨 Important: Setup Required

**Before deploying, you must:**

1. **Add favicon images** to `/public/` (see SETUP.md)
2. **Add OpenGraph image** (`og-image.png`, 1200x630) to `/public/`
3. **Update environment variables** in `.env.local`
4. **Get your App Store URL** and add it to `.env.local`

📖 **Read [SETUP.md](./SETUP.md) for complete setup instructions.**

## Overview

This is the customer-facing support and information website for Early Reader Phonics. It provides:

- **Help & Support**: Working contact form with FormSubmit integration
- **Features Overview**: Highlights of the app's key features
- **Screenshot Gallery**: Showcase your app with beautiful screenshots
- **FAQ Section**: Answers to common questions
- **Terms of Service**: Required for App Store submission
- **Privacy Policy**: Transparent privacy information for parents
- **404 & Loading Pages**: Professional error handling

## Design System

The website matches the vibrant, playful aesthetic of the iOS app:

### Colors
- **Vibrant Pink** (`#FF3380`) - Short Vowels
- **Vibrant Lavender** (`#B34DF2`) - Consonant Blends
- **Vibrant Mint** (`#33E699`) - Digraphs
- **Vibrant Peach** (`#FF9933`) - Diphthongs
- **Vibrant Sky Blue** (`#33A6FF`) - Ending Blends
- **Vibrant Lemon** (`#FFE600`) - Hard & Soft C/G
- **Vibrant Coral** (`#FF594D`) - R-Controlled
- **Vibrant Sage** (`#4DCC80`) - Trigraphs
- **Vibrant Lilac** (`#BF40D9`) - Vowel Teams
- **Vibrant Blue** (`#4D80FF`) - Default

### Typography
- **Headings**: Fredoka (playful, rounded, educational)
- **Body**: Inter (clean, readable)

## Getting Started

### Prerequisites
- Node.js 20+
- npm or pnpm

### Installation

```bash
npm install
```

### Development

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) to view the site.

### Build for Production

```bash
npm run build
npm start
```

## Deployment

This Next.js app can be deployed to:
- **Vercel** (recommended, zero-config) - `vercel.json` included
- **Netlify** - `netlify.toml` included
- **AWS Amplify**
- Any Node.js hosting platform

### Quick Deploy to Vercel

1. Complete setup steps in [SETUP.md](./SETUP.md)
2. Push to GitHub
3. Import project in Vercel
4. Add environment variables in Vercel dashboard
5. Deploy (automatic)

### Environment Variables to Add

```bash
NEXT_PUBLIC_SITE_URL=https://earlyreader.app
NEXT_PUBLIC_APP_STORE_URL=https://apps.apple.com/app/idYOUR_APP_ID
NEXT_PUBLIC_SUPPORT_EMAIL=support@earlyreader.app
NEXT_PUBLIC_FORMSUBMIT_ENDPOINT=support@earlyreader.app
```

## Customization

### 1. Update App Store Link
Set in `.env.local`:
```bash
NEXT_PUBLIC_APP_STORE_URL=https://apps.apple.com/app/idYOUR_APP_ID
```

### 2. Update Support Email
Replace all instances of `support@earlyreader.app` with your email in:
- `.env.local`
- `src/app/page.tsx`
- `src/app/not-found.tsx`
- `src/app/terms/page.tsx`

### 3. Add Real Screenshots
1. Place screenshots in `/public/screenshots/`
2. Update `src/app/page.tsx` screenshot gallery (around line 218)

### 4. Modify Content
All content is in `src/app/page.tsx`:
- Features array (line 4)
- Troubleshooting steps (line 37)
- FAQ items (line 56)

## File Structure

```
client/
├── src/
│   └── app/
│       ├── page.tsx          # Main page component
│       ├── layout.tsx         # Root layout with fonts
│       ├── globals.css        # Global styles & color system
│       └── favicon.ico
├── public/
│   └── note-early-icon-logo-white.png  # App logo
├── package.json
└── README.md
```

## Tech Stack

- **Framework**: Next.js 16 (App Router)
- **Styling**: Tailwind CSS 4
- **Fonts**: Inter, Fredoka (Google Fonts)
- **Language**: TypeScript

## Features

- ✅ Responsive design (mobile, tablet, desktop)
- ✅ Vibrant color scheme matching iOS app
- ✅ Accessible navigation and forms
- ✅ SEO optimized with OpenGraph & Twitter cards
- ✅ Fast page loads with Next.js
- ✅ Smooth animations and transitions
- ✅ Working contact form with FormSubmit
- ✅ Security headers (HSTS, CSP, etc.)
- ✅ PWA manifest for installability
- ✅ 404 and loading pages
- ✅ Terms of Service page
- ✅ Deployment configs (Vercel, Netlify)

## Support

For questions about the website, contact the development team.
For app support, visit the website or email support@earlyreader.app.

## License

This website is part of the Early Reader Phonics project.
