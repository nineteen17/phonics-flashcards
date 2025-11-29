const sharp = require('sharp');
const fs = require('fs');
const path = require('path');

const publicDir = path.join(__dirname, '../public');
const sourceImage = path.join(publicDir, 'note-early-icon-logo-white.png');

const sizes = [
  { name: 'favicon-16x16.png', size: 16 },
  { name: 'favicon-32x32.png', size: 32 },
  { name: 'apple-touch-icon.png', size: 180 },
  { name: 'android-chrome-192x192.png', size: 192 },
  { name: 'android-chrome-512x512.png', size: 512 },
];

async function generateFavicons() {
  console.log('🎨 Generating favicons from logo...\n');

  for (const { name, size } of sizes) {
    try {
      // Simply resize - the logo already has proper sizing
      await sharp(sourceImage)
        .resize(size, size, {
          fit: 'fill' // Fill entire space, no letterboxing
        })
        .toFile(path.join(publicDir, name));

      console.log(`✅ Generated ${name} (${size}x${size})`);
    } catch (error) {
      console.error(`❌ Failed to generate ${name}:`, error.message);
    }
  }

  // Generate og-image (1200x630)
  console.log('\n🎨 Generating OpenGraph image...\n');

  try {
    // Create a gradient background
    const svgBackground = `
      <svg width="1200" height="630">
        <defs>
          <linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color:rgb(179,77,242);stop-opacity:1" />
            <stop offset="100%" style="stop-color:rgb(255,51,128);stop-opacity:1" />
          </linearGradient>
        </defs>
        <rect width="1200" height="630" fill="url(#grad)" />
      </svg>
    `;

    // Generate base gradient
    const background = await sharp(Buffer.from(svgBackground))
      .png()
      .toBuffer();

    // Resize logo and overlay
    const logo = await sharp(sourceImage)
      .resize(300, 300, { fit: 'cover', position: 'center' })
      .toBuffer();

    // Composite logo on background
    await sharp(background)
      .composite([
        { input: logo, left: 450, top: 165 }
      ])
      .toFile(path.join(publicDir, 'og-image.png'));

    console.log('✅ Generated og-image.png (1200x630)\n');
  } catch (error) {
    console.error('❌ Failed to generate og-image:', error.message);
  }

  console.log('\n✨ All images generated successfully!');
  console.log('\n📝 Note: The og-image is basic. For better results, design a custom');
  console.log('   1200x630 image in Canva or Figma with your app name and tagline.\n');
}

generateFavicons().catch(console.error);
