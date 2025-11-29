# Early Reader Phonics - Setup Guide

Complete setup instructions for the support website.

## ✅ Completed Setup

The following has been implemented:

- ✅ Enhanced metadata with OpenGraph and Twitter cards
- ✅ 404 and loading pages
- ✅ Terms of Service page
- ✅ Environment variables configuration
- ✅ FormSubmit contact form integration
- ✅ Screenshot gallery section
- ✅ Security headers
- ✅ Deployment configurations (Vercel & Netlify)
- ✅ Robots.txt and sitemap.xml
- ✅ PWA manifest.json

## 🚨 Required: Add Images

You need to add the following images to the `/public` directory:

### 1. Favicon Images

Generate these from your app icon using a favicon generator (e.g., [favicon.io](https://favicon.io/)):

```
/public/favicon-16x16.png        (16x16 pixels)
/public/favicon-32x32.png        (32x32 pixels)
/public/apple-touch-icon.png     (180x180 pixels)
/public/android-chrome-192x192.png (192x192 pixels)
/public/android-chrome-512x512.png (512x512 pixels)
```

**Quick Generate:**
1. Go to https://favicon.io/favicon-converter/
2. Upload your app icon (1024x1024 recommended)
3. Download the generated favicons
4. Copy them to `/public/`

### 2. OpenGraph Image

Create a social sharing image for Facebook, Twitter, LinkedIn:

```
/public/og-image.png (1200x630 pixels)
```

**Tips for creating:**
- Use app branding colors (vibrant lavender, pink)
- Include app icon/logo
- Add text: "Early Reader Phonics - Learn to Read"
- Use Canva or Figma with 1200x630 template

### 3. App Screenshots (Optional but Recommended)

Copy 3-6 screenshots from your app to:

```
/public/screenshots/screenshot-1.png
/public/screenshots/screenshot-2.png
/public/screenshots/screenshot-3.png
```

Then update `/src/app/page.tsx` around line 218 to use real images instead of placeholders.

## 🔧 Configuration Steps

### 1. Update Environment Variables

Edit `.env.local` with your actual values:

```bash
# Your production URL
NEXT_PUBLIC_SITE_URL=https://earlyreader.app

# Your actual App Store URL (get this after app is published)
NEXT_PUBLIC_APP_STORE_URL=https://apps.apple.com/app/idYOUR_APP_ID

# Your support email
NEXT_PUBLIC_SUPPORT_EMAIL=support@earlyreader.app

# FormSubmit endpoint (use your email)
NEXT_PUBLIC_FORMSUBMIT_ENDPOINT=support@earlyreader.app
```

### 2. Verify FormSubmit Setup

FormSubmit is already integrated. On first form submission:

1. User submits the contact form
2. FormSubmit sends a confirmation email to `NEXT_PUBLIC_FORMSUBMIT_ENDPOINT`
3. Click the confirmation link in that email
4. Future submissions will work automatically

**Alternative:** Use your own backend API by changing the form action in `src/app/page.tsx` line 277.

### 3. Update Sitemap

Edit `/public/sitemap.xml`:
- Replace all instances of `https://earlyreader.app` with your actual domain
- Update the `<lastmod>` date to today

## 🚀 Deployment

### Option 1: Vercel (Recommended)

1. Push your code to GitHub
2. Go to [vercel.com](https://vercel.com)
3. Click "Import Project"
4. Select your repository
5. Add environment variables in Vercel dashboard:
   - `NEXT_PUBLIC_SITE_URL`
   - `NEXT_PUBLIC_APP_STORE_URL`
   - `NEXT_PUBLIC_SUPPORT_EMAIL`
   - `NEXT_PUBLIC_FORMSUBMIT_ENDPOINT`
6. Deploy

### Option 2: Netlify

1. Push your code to GitHub
2. Go to [netlify.com](https://netlify.com)
3. Click "Add new site" → "Import from Git"
4. Select your repository
5. Build settings are auto-detected from `netlify.toml`
6. Add environment variables in Netlify dashboard
7. Deploy

### Option 3: Self-Hosted

```bash
npm run build
npm start
```

Use a process manager like PM2:

```bash
npm install -g pm2
pm2 start npm --name "early-reader-web" -- start
pm2 save
```

## 📝 Customization

### Update Support Email

Replace all instances of `support@earlyreader.app` with your email:

```bash
cd /Users/nickririnui/Desktop/phonics-flashcards/client
grep -r "support@earlyreader.app" src/
```

Update in:
- `src/app/page.tsx`
- `src/app/not-found.tsx`
- `src/app/terms/page.tsx`
- `.env.local`

### Add Real Screenshots

1. Export screenshots from your iOS app (iPhone 16 Pro recommended)
2. Copy to `/public/screenshots/`
3. Update `src/app/page.tsx` screenshot gallery section (line ~218)

Replace the placeholder divs with:

```tsx
<Image
  src="/screenshots/screenshot-1.png"
  alt="App screenshot"
  width={400}
  height={866}
  className="rounded-2xl"
/>
```

### Modify Colors

All app colors are defined in `src/app/globals.css` lines 3-18. They match your iOS app's vibrant palette.

## 🧪 Testing

### Local Testing

```bash
npm run dev
```

Visit http://localhost:3000

### Build Testing

```bash
npm run build
npm start
```

### Test Contact Form

1. Fill out the contact form
2. Check your email for FormSubmit confirmation
3. Click the confirmation link
4. Test submission again

### SEO Testing

Use these tools:
- [Google Rich Results Test](https://search.google.com/test/rich-results)
- [Twitter Card Validator](https://cards-dev.twitter.com/validator)
- [Facebook Sharing Debugger](https://developers.facebook.com/tools/debug/)

## 📱 Mobile Testing

Test on:
- iPhone (Safari, Chrome)
- Android (Chrome, Firefox)
- Tablet devices

Verify:
- Contact form works
- Navigation is smooth
- Images load correctly
- Text is readable

## 🔒 Security Checklist

- ✅ Security headers configured
- ✅ HTTPS only (configure on deployment platform)
- ✅ No sensitive data in client code
- ✅ Form spam protection (FormSubmit has built-in protection)
- ✅ No inline scripts (CSP-friendly)

## 📊 Analytics (Optional)

To add analytics, uncomment in `.env.local`:

### Google Analytics

```bash
NEXT_PUBLIC_GA_TRACKING_ID=G-XXXXXXXXXX
```

Then add to `src/app/layout.tsx`:

```tsx
import Script from 'next/script'

// In <head>
<Script
  src={`https://www.googletagmanager.com/gtag/js?id=${process.env.NEXT_PUBLIC_GA_TRACKING_ID}`}
  strategy="afterInteractive"
/>
```

### Plausible Analytics (Privacy-friendly)

```bash
NEXT_PUBLIC_PLAUSIBLE_DOMAIN=earlyreader.app
```

Add to `src/app/layout.tsx`:

```tsx
<Script
  defer
  data-domain={process.env.NEXT_PUBLIC_PLAUSIBLE_DOMAIN}
  src="https://plausible.io/js/script.js"
/>
```

## 🐛 Troubleshooting

### Build Errors

If you see TypeScript errors:

```bash
npm run lint
```

### Environment Variables Not Working

Ensure all `NEXT_PUBLIC_*` variables are set in your deployment platform dashboard.

### Images Not Loading

Check that images are in `/public/` directory (not `/public/public/`).

### FormSubmit Not Working

1. Check email confirmation was clicked
2. Verify `NEXT_PUBLIC_FORMSUBMIT_ENDPOINT` is set correctly
3. Check browser console for errors

## 📚 Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [FormSubmit Documentation](https://formsubmit.co/)
- [Vercel Deployment Guide](https://vercel.com/docs)

## ✉️ Support

For questions about this setup, contact your development team.
