#!/bin/bash

# Generate placeholder images for development
# This creates temporary placeholder images so the site can run
# Replace these with real images before deploying to production

echo "Generating placeholder images for development..."

# Create public directory if it doesn't exist
mkdir -p public

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick not found. Installing via Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not installed. Please install ImageMagick manually:"
        echo "brew install imagemagick"
        exit 1
    fi
    brew install imagemagick
fi

# Generate favicon-16x16.png
convert -size 16x16 xc:"#B34DF2" \
    -gravity center \
    -pointsize 10 -font Arial-Bold \
    -fill white -annotate +0+0 "ER" \
    public/favicon-16x16.png

# Generate favicon-32x32.png
convert -size 32x32 xc:"#B34DF2" \
    -gravity center \
    -pointsize 20 -font Arial-Bold \
    -fill white -annotate +0+0 "ER" \
    public/favicon-32x32.png

# Generate apple-touch-icon.png
convert -size 180x180 xc:"#B34DF2" \
    -gravity center \
    -pointsize 60 -font Arial-Bold \
    -fill white -annotate +0+0 "ER" \
    public/apple-touch-icon.png

# Generate android-chrome-192x192.png
convert -size 192x192 xc:"#B34DF2" \
    -gravity center \
    -pointsize 70 -font Arial-Bold \
    -fill white -annotate +0+0 "ER" \
    public/android-chrome-192x192.png

# Generate android-chrome-512x512.png
convert -size 512x512 xc:"#B34DF2" \
    -gravity center \
    -pointsize 180 -font Arial-Bold \
    -fill white -annotate +0+0 "ER" \
    public/android-chrome-512x512.png

# Generate og-image.png (1200x630)
convert -size 1200x630 \
    gradient:"#B34DF2-#FF3380" \
    -gravity center \
    -pointsize 80 -font Arial-Bold \
    -fill white -annotate +0-50 "Early Reader Phonics" \
    -pointsize 40 -font Arial \
    -fill white -annotate +0+50 "Learn to Read with Fun Flashcards" \
    public/og-image.png

echo "✅ Placeholder images generated successfully!"
echo ""
echo "⚠️  IMPORTANT: These are placeholder images for development only."
echo "Replace them with real images from your app before deploying to production."
echo ""
echo "Images created:"
echo "  - public/favicon-16x16.png"
echo "  - public/favicon-32x32.png"
echo "  - public/apple-touch-icon.png"
echo "  - public/android-chrome-192x192.png"
echo "  - public/android-chrome-512x512.png"
echo "  - public/og-image.png"
