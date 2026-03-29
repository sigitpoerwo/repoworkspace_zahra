---
name: expert-frontend
description: "Used automatically when building UI/Interfaces. Enforces world-class UI/UX, animations, premium Tailwind aesthetics, and modern web design principles."
metadata: { "openclaw": { "emoji": "🎨", "requires": { "bins": [] } } }
---

# 🎨 UI/UX Architecture (Premium Frontend)

## Overview
As a Frontend Master, you do NOT build ugly or "generic" MVPs. You design and implement world-class, fluid, extremely premium web interfaces that WOW the user instantly.

## The Pillars of Premium Design

### 1. Superior Aesthetics & Typography
- Avoid defaults. No generic `#ff0000` reds or standard blues.
- Use curated HTML color palettes (e.g., sleek dark modes with subtle zinc/slate gradients, bright vibrant semantic brand colors).
- Rely on modern Google fonts (`Inter`, `Outfit`, `Plus Jakarta Sans`) rather than system sans-serif.

### 2. Interaction & Micro-animations
- A premium frontend must feel alive.
- Add CSS hover animations (`hover:scale-105`, `transition-all`, `duration-300`).
- Ensure load-ins employ smooth fade or translate transformations (using `framer-motion` or Tailwind `animate-in`).

### 3. Glassmorphism & Depth
- Add depth. Flat UIs are boring.
- Use subtle box-shadows, frosted glass effects (`backdrop-blur-md bg-white/10` in dark mode).
- Use proper hierarchical spacing (margins and paddings must breathe properly).

### 4. Responsiveness 
- Code must look perfect on a 320px mobile screen and an Ultrawide desktop. Include fluid grids, proper flex-wrapping, and avoid hardcoded heights where possible.

## 🛑 Hard Rules for Frontend Generation
- **NEVER** leave placeholder boxes `[Image Goes Here]`. Generate mock images via `generate_image` or use real high-quality Unsplash URLs.
- **NEVER** use 1990s HTML tables for modern layout. Always rely heavily on Tailwind Flex/Grid.
- Assume accessibility out of the gate (`aria-labels`, focus rings, proper contrast).

---

## 📚 Examples

### Example 1: Premium Hero Section

**Bad (Generic):**
```jsx
<div className="hero">
  <h1>Welcome to Our Site</h1>
  <p>We are the best</p>
  <button>Get Started</button>
</div>
```

**Good (Premium):**
```jsx
<section className="relative min-h-screen flex items-center justify-center overflow-hidden bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900">
  {/* Animated background */}
  <div className="absolute inset-0 bg-[url('/grid.svg')] opacity-20" />
  
  {/* Glassmorphic card */}
  <div className="relative z-10 max-w-4xl mx-auto px-6 text-center">
    <div className="backdrop-blur-xl bg-white/10 rounded-3xl p-12 border border-white/20 shadow-2xl">
      <h1 className="text-6xl md:text-7xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-purple-400 to-pink-600 mb-6 animate-in fade-in slide-in-from-bottom-4 duration-1000">
        Welcome to the Future
      </h1>
      
      <p className="text-xl text-slate-300 mb-8 max-w-2xl mx-auto animate-in fade-in slide-in-from-bottom-4 duration-1000 delay-200">
        Experience world-class design that sets new standards in digital excellence
      </p>
      
      <button className="group relative px-8 py-4 bg-gradient-to-r from-purple-600 to-pink-600 rounded-full font-semibold text-white shadow-lg hover:shadow-purple-500/50 transition-all duration-300 hover:scale-105 animate-in fade-in slide-in-from-bottom-4 duration-1000 delay-400">
        <span className="relative z-10">Get Started</span>
        <div className="absolute inset-0 rounded-full bg-gradient-to-r from-purple-400 to-pink-400 opacity-0 group-hover:opacity-100 transition-opacity duration-300 blur" />
      </button>
    </div>
  </div>
  
  {/* Floating elements */}
  <div className="absolute top-20 left-10 w-72 h-72 bg-purple-500 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-blob" />
  <div className="absolute top-40 right-10 w-72 h-72 bg-pink-500 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-blob animation-delay-2000" />
</section>
```

### Example 2: Premium Card Component

**Bad (Generic):**
```jsx
<div className="card">
  <img src="/image.jpg" alt="Product" />
  <h3>Product Name</h3>
  <p>$99</p>
  <button>Buy Now</button>
</div>
```

**Good (Premium):**
```jsx
<div className="group relative overflow-hidden rounded-2xl bg-gradient-to-br from-slate-800 to-slate-900 p-1 transition-all duration-300 hover:scale-[1.02] hover:shadow-2xl hover:shadow-purple-500/20">
  {/* Gradient border effect */}
  <div className="absolute inset-0 bg-gradient-to-r from-purple-600 to-pink-600 opacity-0 group-hover:opacity-100 transition-opacity duration-300 blur-xl" />
  
  <div className="relative bg-slate-900 rounded-2xl overflow-hidden">
    {/* Image with overlay */}
    <div className="relative h-64 overflow-hidden">
      <img 
        src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800" 
        alt="Premium Product"
        className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
      />
      <div className="absolute inset-0 bg-gradient-to-t from-slate-900 via-slate-900/50 to-transparent opacity-60" />
      
      {/* Badge */}
      <div className="absolute top-4 right-4 px-3 py-1 bg-purple-600/90 backdrop-blur-sm rounded-full text-xs font-semibold text-white">
        NEW
      </div>
    </div>
    
    {/* Content */}
    <div className="p-6">
      <h3 className="text-2xl font-bold text-white mb-2 group-hover:text-purple-400 transition-colors">
        Premium Product
      </h3>
      
      <p className="text-slate-400 mb-4">
        Experience luxury with cutting-edge technology
      </p>
      
      <div className="flex items-center justify-between">
        <span className="text-3xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-purple-400 to-pink-600">
          $99
        </span>
        
        <button className="px-6 py-3 bg-gradient-to-r from-purple-600 to-pink-600 rounded-xl font-semibold text-white shadow-lg hover:shadow-purple-500/50 transition-all duration-300 hover:scale-105">
          Buy Now
        </button>
      </div>
    </div>
  </div>
</div>
```

### Example 3: Premium Navigation

**Bad (Generic):**
```jsx
<nav>
  <a href="/">Home</a>
  <a href="/about">About</a>
  <a href="/contact">Contact</a>
</nav>
```

**Good (Premium):**
```jsx
<nav className="fixed top-0 left-0 right-0 z-50 backdrop-blur-xl bg-slate-900/80 border-b border-white/10">
  <div className="max-w-7xl mx-auto px-6 py-4">
    <div className="flex items-center justify-between">
      {/* Logo */}
      <div className="flex items-center space-x-2">
        <div className="w-10 h-10 bg-gradient-to-br from-purple-600 to-pink-600 rounded-xl flex items-center justify-center">
          <span className="text-white font-bold text-xl">B</span>
        </div>
        <span className="text-xl font-bold text-white">Brand</span>
      </div>
      
      {/* Navigation Links */}
      <div className="hidden md:flex items-center space-x-1">
        {['Home', 'About', 'Services', 'Contact'].map((item) => (
          <a
            key={item}
            href={`/${item.toLowerCase()}`}
            className="px-4 py-2 text-slate-300 hover:text-white rounded-lg hover:bg-white/10 transition-all duration-200"
          >
            {item}
          </a>
        ))}
      </div>
      
      {/* CTA Button */}
      <button className="px-6 py-2 bg-gradient-to-r from-purple-600 to-pink-600 rounded-lg font-semibold text-white shadow-lg hover:shadow-purple-500/50 transition-all duration-300 hover:scale-105">
        Get Started
      </button>
    </div>
  </div>
</nav>
```

---

## 🎯 Use Cases

### Use Case 1: SaaS Landing Page

**When to use:** Building a landing page for a SaaS product

**Key elements:**
- Hero section with gradient background
- Feature cards with glassmorphism
- Pricing table with hover effects
- Testimonials with smooth animations
- CTA sections with gradient buttons

**Example structure:**
```jsx
<main className="bg-slate-900 text-white">
  <HeroSection />
  <FeaturesSection />
  <PricingSection />
  <TestimonialsSection />
  <CTASection />
</main>
```

### Use Case 2: E-commerce Product Page

**When to use:** Building a product detail page

**Key elements:**
- Image gallery with zoom effect
- Product info with gradient accents
- Add to cart button with animation
- Related products carousel
- Reviews section with star ratings

**Example structure:**
```jsx
<div className="max-w-7xl mx-auto px-6 py-12">
  <div className="grid md:grid-cols-2 gap-12">
    <ProductGallery />
    <ProductInfo />
  </div>
  <RelatedProducts />
  <ReviewsSection />
</div>
```

### Use Case 3: Dashboard Interface

**When to use:** Building an admin or user dashboard

**Key elements:**
- Sidebar with glassmorphic effect
- Stats cards with gradient borders
- Charts with smooth animations
- Data tables with hover states
- Action buttons with micro-interactions

**Example structure:**
```jsx
<div className="flex min-h-screen bg-slate-900">
  <Sidebar />
  <main className="flex-1 p-8">
    <StatsGrid />
    <ChartsSection />
    <DataTable />
  </main>
</div>
```

---

## 🔧 Advanced Techniques

### 1. Glassmorphism Effect

```css
/* Tailwind classes */
.glass {
  @apply backdrop-blur-xl bg-white/10 border border-white/20 shadow-2xl;
}

/* Dark mode variant */
.glass-dark {
  @apply backdrop-blur-xl bg-slate-900/80 border border-white/10 shadow-2xl;
}
```

### 2. Gradient Text

```jsx
<h1 className="text-6xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-purple-400 via-pink-500 to-red-500">
  Gradient Text
</h1>
```

### 3. Animated Blob Background

```jsx
<div className="relative">
  <div className="absolute top-0 -left-4 w-72 h-72 bg-purple-300 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob" />
  <div className="absolute top-0 -right-4 w-72 h-72 bg-yellow-300 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob animation-delay-2000" />
  <div className="absolute -bottom-8 left-20 w-72 h-72 bg-pink-300 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob animation-delay-4000" />
</div>

{/* Add to tailwind.config.js */}
animation: {
  blob: "blob 7s infinite",
},
keyframes: {
  blob: {
    "0%": { transform: "translate(0px, 0px) scale(1)" },
    "33%": { transform: "translate(30px, -50px) scale(1.1)" },
    "66%": { transform: "translate(-20px, 20px) scale(0.9)" },
    "100%": { transform: "translate(0px, 0px) scale(1)" },
  },
}
```

### 4. Hover Glow Effect

```jsx
<button className="group relative px-8 py-4 bg-purple-600 rounded-xl font-semibold text-white transition-all duration-300 hover:scale-105">
  <span className="relative z-10">Hover Me</span>
  <div className="absolute inset-0 rounded-xl bg-purple-400 opacity-0 group-hover:opacity-100 transition-opacity duration-300 blur-xl" />
</button>
```

### 5. Smooth Page Transitions (Framer Motion)

```jsx
import { motion } from 'framer-motion';

<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  exit={{ opacity: 0, y: -20 }}
  transition={{ duration: 0.3 }}
>
  {children}
</motion.div>
```

---

## 🚀 Performance Best Practices

### 1. Image Optimization

```jsx
import Image from 'next/image';

<Image
  src="/hero.jpg"
  alt="Hero"
  width={1920}
  height={1080}
  priority
  className="object-cover"
/>
```

### 2. Lazy Loading

```jsx
import { lazy, Suspense } from 'react';

const HeavyComponent = lazy(() => import('./HeavyComponent'));

<Suspense fallback={<LoadingSpinner />}>
  <HeavyComponent />
</Suspense>
```

### 3. CSS-in-JS Optimization

```jsx
// Use Tailwind instead of runtime CSS-in-JS
// Bad: styled-components with dynamic styles
// Good: Tailwind with conditional classes

<div className={cn(
  "base-classes",
  isActive && "active-classes",
  variant === "primary" && "primary-classes"
)} />
```

---

## ♿ Accessibility Checklist

- [ ] All images have descriptive `alt` text
- [ ] Interactive elements have `aria-labels`
- [ ] Focus states are visible (not `outline-none` without replacement)
- [ ] Color contrast meets WCAG AA standards (4.5:1 for text)
- [ ] Keyboard navigation works (Tab, Enter, Escape)
- [ ] Screen reader friendly (semantic HTML)
- [ ] Form inputs have associated labels
- [ ] Error messages are announced
- [ ] Loading states are communicated
- [ ] Animations respect `prefers-reduced-motion`

---

## 🐛 Troubleshooting

### Issue: Tailwind classes not working

**Solution:**
```js
// tailwind.config.js
module.exports = {
  content: [
    './src/**/*.{js,jsx,ts,tsx}',
    './app/**/*.{js,jsx,ts,tsx}',
  ],
  // ...
}
```

### Issue: Animations not smooth

**Solution:**
```jsx
// Add will-change for better performance
<div className="will-change-transform transition-transform duration-300 hover:scale-105">
  Content
</div>
```

### Issue: Glassmorphism not visible

**Solution:**
```jsx
// Ensure parent has background
<div className="bg-slate-900">
  <div className="backdrop-blur-xl bg-white/10">
    Glassmorphic content
  </div>
</div>
```

### Issue: Gradient text not showing

**Solution:**
```jsx
// Ensure all required classes are present
<h1 className="bg-clip-text text-transparent bg-gradient-to-r from-purple-400 to-pink-600">
  Gradient Text
</h1>
```

### Issue: Mobile responsiveness broken

**Solution:**
```jsx
// Use mobile-first approach
<div className="flex flex-col md:flex-row gap-4">
  {/* Content */}
</div>

// Add viewport meta tag
<meta name="viewport" content="width=device-width, initial-scale=1" />
```

---

## 📝 Component Library Recommendations

### UI Components
- **shadcn/ui** - Beautifully designed components
- **Radix UI** - Unstyled, accessible components
- **Headless UI** - Tailwind-friendly components

### Animation Libraries
- **Framer Motion** - Production-ready animations
- **GSAP** - Professional-grade animations
- **Auto Animate** - Zero-config animations

### Icons
- **Lucide React** - Beautiful, consistent icons
- **Heroicons** - Tailwind-designed icons
- **Phosphor Icons** - Flexible icon family

---

## 🎨 Color Palette Examples

### Dark Mode (Recommended)
```js
colors: {
  primary: {
    50: '#faf5ff',
    100: '#f3e8ff',
    // ... purple scale
    900: '#581c87',
  },
  accent: {
    // ... pink scale
  },
  background: {
    DEFAULT: '#0f172a', // slate-900
    card: '#1e293b',    // slate-800
  }
}
```

### Light Mode
```js
colors: {
  primary: {
    // ... blue scale
  },
  background: {
    DEFAULT: '#ffffff',
    card: '#f8fafc',    // slate-50
  }
}
```

---

## 📚 Additional Resources

- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Framer Motion Documentation](https://www.framer.com/motion/)
- [Web.dev Accessibility](https://web.dev/accessibility/)
- [Awwwards](https://www.awwwards.com/) - Design inspiration
- [Dribbble](https://dribbble.com/) - UI/UX inspiration
