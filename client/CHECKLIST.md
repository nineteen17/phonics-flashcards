# Pre-Deployment Checklist

Use this checklist to ensure your website is ready for production.

## 🖼️ Images (REQUIRED)

- [ ] Generate and add favicon images to `/public/`:
  - [ ] `favicon-16x16.png` (16x16)
  - [ ] `favicon-32x32.png` (32x32)
  - [ ] `apple-touch-icon.png` (180x180)
  - [ ] `android-chrome-192x192.png` (192x192)
  - [ ] `android-chrome-512x512.png` (512x512)

  **Tool:** Use https://favicon.io/favicon-converter/

- [ ] Create and add OpenGraph image:
  - [ ] `og-image.png` (1200x630) to `/public/`

  **Tool:** Use Canva or Figma with 1200x630 template

## 📝 Configuration (REQUIRED)

- [ ] Update `.env.local` with actual values:
  - [ ] `NEXT_PUBLIC_SITE_URL` (your production URL)
  - [ ] `NEXT_PUBLIC_APP_STORE_URL` (get after app is published)
  - [ ] `NEXT_PUBLIC_SUPPORT_EMAIL` (your support email)
  - [ ] `NEXT_PUBLIC_FORMSUBMIT_ENDPOINT` (same as support email)

- [ ] Update `/public/sitemap.xml`:
  - [ ] Replace `https://earlyreader.app` with your domain
  - [ ] Update `<lastmod>` date to today

- [ ] Update `/public/robots.txt`:
  - [ ] Replace sitemap URL with your domain

## 📧 Email Setup (REQUIRED)

- [ ] Test FormSubmit contact form:
  1. [ ] Fill out contact form on local site
  2. [ ] Check email for FormSubmit confirmation
  3. [ ] Click confirmation link
  4. [ ] Test form submission again

## 📱 App Store (REQUIRED BEFORE LAUNCH)

- [ ] Publish app to App Store
- [ ] Get App Store URL
- [ ] Update `NEXT_PUBLIC_APP_STORE_URL` in `.env.local`
- [ ] Test download button redirects correctly

## 🎨 Optional Enhancements

- [ ] Add real app screenshots:
  - [ ] Export 3-6 screenshots from iOS app
  - [ ] Copy to `/public/screenshots/`
  - [ ] Update screenshot gallery in `src/app/page.tsx` (line ~218)

- [ ] Customize content:
  - [ ] Update features array (line 4)
  - [ ] Update troubleshooting steps (line 37)
  - [ ] Update FAQ items (line 56)

- [ ] Add analytics (optional):
  - [ ] Choose analytics provider (Google Analytics, Plausible, etc.)
  - [ ] Add tracking code to `src/app/layout.tsx`

## 🧪 Testing

- [ ] Test locally:
  ```bash
  npm run dev
  ```
  - [ ] All pages load correctly
  - [ ] Contact form works
  - [ ] All links work
  - [ ] Images display correctly

- [ ] Test production build:
  ```bash
  npm run build
  npm start
  ```
  - [ ] No build errors
  - [ ] Site works in production mode

- [ ] Test on devices:
  - [ ] iPhone (Safari)
  - [ ] Android (Chrome)
  - [ ] Desktop (Chrome, Firefox, Safari)
  - [ ] Tablet

- [ ] Test SEO:
  - [ ] https://search.google.com/test/rich-results
  - [ ] https://cards-dev.twitter.com/validator
  - [ ] https://developers.facebook.com/tools/debug/

## 🚀 Deployment

Choose one:

### Option A: Vercel
- [ ] Push code to GitHub
- [ ] Import project in Vercel
- [ ] Add environment variables in dashboard
- [ ] Deploy
- [ ] Test production URL

### Option B: Netlify
- [ ] Push code to GitHub
- [ ] Import project in Netlify
- [ ] Add environment variables in dashboard
- [ ] Deploy
- [ ] Test production URL

## 🔒 Security

- [ ] Verify HTTPS is enabled on production
- [ ] Test security headers (use https://securityheaders.com/)
- [ ] Ensure no sensitive data in client code
- [ ] Test CSP doesn't block legitimate resources

## 📊 Post-Launch

- [ ] Submit sitemap to Google Search Console
- [ ] Monitor contact form submissions
- [ ] Check analytics (if configured)
- [ ] Monitor for errors in deployment platform logs

## ✅ Final Checks

- [ ] All TODO items above completed
- [ ] Site accessible at production URL
- [ ] Download button links to App Store
- [ ] Contact form sends emails successfully
- [ ] No console errors on any page
- [ ] Mobile responsive design works
- [ ] Fast page load times (< 3 seconds)

---

**Need Help?** See [SETUP.md](./SETUP.md) for detailed instructions.
