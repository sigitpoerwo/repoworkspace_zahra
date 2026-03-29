---
name: expert-nextjs
description: "React 19 & Next.js 15 App Router Expert. Emphasizes React Server Components, hydration performance, SEO, Server Actions, modern best practices."
metadata: { "openclaw": { "emoji": "⚛️", "requires": { "bins": [] } } }
---

# ⚛️ Next.js App Router Architecture Expert

## Overview
As a Next.js Expert, you design code leveraging React Server Components (RSC) and Server Actions while keeping the client bundle size nearly zero.

## Key Directives

### 1. Server Components vs Client Components
- Everything is a Server Component by default (`page.tsx`, `layout.tsx`).
- ONLY use `"use client"` when you need browser APIs, hooks (`useState`, `useEffect`), or interactions (`onClick`).
- NEVER import a Server Component into a Client Component (Pass it as a prop or `children` instead).

### 2. Server Actions for Mutations
- Forms and data mutations should use `"use server"` Server Actions natively integrated with React 19 `useActionState` and `<form action={fn}>`.
- Drop traditional API Routes unless explicitly building a public-facing REST/Webhook endpoint. Use Server Actions to mutate directly from the UI.

### 3. Data Fetching
- Fetch data directly in Server Components (using standard `async/await fetch()`).
- Leverage Next.js cache layers correctly (`force-cache`, `no-store`, `revalidatePath`, `revalidateTag`).

### 4. Code Quality & Standards
- Avoid messy `useEffect` data fetching loops.
- Use native Next.js `<Image>`, `<Link>`, and `<Script>` components.
- Leverage `next/navigation` over legacy packages.
- Ensure SEO logic (metadata, OpenGraph, dynamic sitemaps) is generated cleanly inside `layout.tsx` or `page.tsx`.

---

## 📚 Examples

### Example 1: Server Component with Data Fetching

**Bad (Client-side fetching):**
```tsx
'use client';
import { useEffect, useState } from 'react';

export default function Page() {
  const [data, setData] = useState(null);
  
  useEffect(() => {
    fetch('/api/posts')
      .then(res => res.json())
      .then(setData);
  }, []);
  
  if (!data) return <div>Loading...</div>;
  return <div>{data.title}</div>;
}
```

**Good (Server Component):**
```tsx
// app/posts/page.tsx
async function getPosts() {
  const res = await fetch('https://api.example.com/posts', {
    next: { revalidate: 3600 } // Cache for 1 hour
  });
  
  if (!res.ok) throw new Error('Failed to fetch posts');
  return res.json();
}

export default async function PostsPage() {
  const posts = await getPosts();
  
  return (
    <div className="grid gap-6">
      {posts.map((post) => (
        <article key={post.id} className="p-6 bg-white rounded-lg shadow">
          <h2 className="text-2xl font-bold">{post.title}</h2>
          <p className="text-gray-600">{post.excerpt}</p>
        </article>
      ))}
    </div>
  );
}
```

### Example 2: Server Actions for Form Submission

**Bad (API Route + Client fetch):**
```tsx
// app/api/posts/route.ts
export async function POST(request: Request) {
  const data = await request.json();
  // Save to database
  return Response.json({ success: true });
}

// app/posts/new/page.tsx
'use client';
export default function NewPost() {
  const handleSubmit = async (e) => {
    e.preventDefault();
    await fetch('/api/posts', {
      method: 'POST',
      body: JSON.stringify(data)
    });
  };
  
  return <form onSubmit={handleSubmit}>...</form>;
}
```

**Good (Server Action):**
```tsx
// app/posts/actions.ts
'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

export async function createPost(formData: FormData) {
  const title = formData.get('title') as string;
  const content = formData.get('content') as string;
  
  // Validate
  if (!title || !content) {
    return { error: 'Title and content are required' };
  }
  
  // Save to database
  await db.post.create({
    data: { title, content }
  });
  
  // Revalidate and redirect
  revalidatePath('/posts');
  redirect('/posts');
}

// app/posts/new/page.tsx
import { createPost } from './actions';

export default function NewPostPage() {
  return (
    <form action={createPost} className="space-y-4">
      <input
        name="title"
        placeholder="Title"
        className="w-full px-4 py-2 border rounded"
        required
      />
      <textarea
        name="content"
        placeholder="Content"
        className="w-full px-4 py-2 border rounded"
        rows={10}
        required
      />
      <button
        type="submit"
        className="px-6 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
      >
        Create Post
      </button>
    </form>
  );
}
```

### Example 3: Client Component with Server Component Children

**Bad (Importing Server Component in Client):**
```tsx
'use client';
import ServerComponent from './ServerComponent'; // ❌ Error!

export default function ClientWrapper() {
  const [open, setOpen] = useState(false);
  return (
    <div>
      <button onClick={() => setOpen(!open)}>Toggle</button>
      {open && <ServerComponent />} {/* ❌ Won't work */}
    </div>
  );
}
```

**Good (Pass as children):**
```tsx
// app/components/ClientWrapper.tsx
'use client';

export default function ClientWrapper({ children }: { children: React.ReactNode }) {
  const [open, setOpen] = useState(false);
  
  return (
    <div>
      <button onClick={() => setOpen(!open)}>Toggle</button>
      {open && children}
    </div>
  );
}

// app/page.tsx (Server Component)
import ClientWrapper from './components/ClientWrapper';
import ServerContent from './components/ServerContent';

export default function Page() {
  return (
    <ClientWrapper>
      <ServerContent /> {/* ✅ Works! */}
    </ClientWrapper>
  );
}
```

### Example 4: Dynamic Metadata for SEO

```tsx
// app/posts/[id]/page.tsx
import { Metadata } from 'next';

type Props = {
  params: { id: string };
};

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const post = await getPost(params.id);
  
  return {
    title: post.title,
    description: post.excerpt,
    openGraph: {
      title: post.title,
      description: post.excerpt,
      images: [post.coverImage],
      type: 'article',
      publishedTime: post.publishedAt,
    },
    twitter: {
      card: 'summary_large_image',
      title: post.title,
      description: post.excerpt,
      images: [post.coverImage],
    },
  };
}

export default async function PostPage({ params }: Props) {
  const post = await getPost(params.id);
  
  return (
    <article>
      <h1>{post.title}</h1>
      <div dangerouslySetInnerHTML={{ __html: post.content }} />
    </article>
  );
}
```

---

## 🎯 Use Cases

### Use Case 1: E-commerce Product Page

**When to use:** Building a product detail page with dynamic data

**Structure:**
```tsx
// app/products/[id]/page.tsx
import { Suspense } from 'react';
import ProductDetails from './ProductDetails';
import RelatedProducts from './RelatedProducts';
import Reviews from './Reviews';
import AddToCartButton from './AddToCartButton';

export default async function ProductPage({ params }: { params: { id: string } }) {
  // Fetch product data on server
  const product = await getProduct(params.id);
  
  return (
    <div className="max-w-7xl mx-auto px-6 py-12">
      <div className="grid md:grid-cols-2 gap-12">
        {/* Server Component */}
        <ProductDetails product={product} />
        
        <div>
          <h1 className="text-3xl font-bold">{product.name}</h1>
          <p className="text-2xl font-bold text-purple-600">${product.price}</p>
          
          {/* Client Component for interactivity */}
          <AddToCartButton productId={product.id} />
        </div>
      </div>
      
      {/* Streaming with Suspense */}
      <Suspense fallback={<div>Loading related products...</div>}>
        <RelatedProducts categoryId={product.categoryId} />
      </Suspense>
      
      <Suspense fallback={<div>Loading reviews...</div>}>
        <Reviews productId={product.id} />
      </Suspense>
    </div>
  );
}
```

### Use Case 2: Dashboard with Real-time Data

**When to use:** Building an admin dashboard

**Structure:**
```tsx
// app/dashboard/page.tsx
import { Suspense } from 'react';
import StatsCards from './StatsCards';
import RecentOrders from './RecentOrders';
import Chart from './Chart';

export const revalidate = 60; // Revalidate every 60 seconds

export default async function DashboardPage() {
  // Parallel data fetching
  const [stats, orders] = await Promise.all([
    getStats(),
    getRecentOrders()
  ]);
  
  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold mb-8">Dashboard</h1>
      
      {/* Server Component with data */}
      <StatsCards stats={stats} />
      
      {/* Client Component for interactivity */}
      <Suspense fallback={<div>Loading chart...</div>}>
        <Chart data={stats.chartData} />
      </Suspense>
      
      {/* Server Component with data */}
      <RecentOrders orders={orders} />
    </div>
  );
}
```

### Use Case 3: Blog with Incremental Static Regeneration

**When to use:** Building a blog with frequently updated content

**Structure:**
```tsx
// app/blog/[slug]/page.tsx
export const revalidate = 3600; // Revalidate every hour

export async function generateStaticParams() {
  const posts = await getAllPosts();
  return posts.map((post) => ({ slug: post.slug }));
}

export default async function BlogPost({ params }: { params: { slug: string } }) {
  const post = await getPostBySlug(params.slug);
  
  return (
    <article className="prose lg:prose-xl mx-auto">
      <h1>{post.title}</h1>
      <time>{post.publishedAt}</time>
      <div dangerouslySetInnerHTML={{ __html: post.content }} />
    </article>
  );
}
```

---

## 🔧 Advanced Patterns

### 1. Parallel Data Fetching

```tsx
export default async function Page() {
  // ❌ Bad: Sequential (slow)
  const user = await getUser();
  const posts = await getPosts();
  
  // ✅ Good: Parallel (fast)
  const [user, posts] = await Promise.all([
    getUser(),
    getPosts()
  ]);
  
  return <div>...</div>;
}
```

### 2. Streaming with Suspense

```tsx
import { Suspense } from 'react';

export default function Page() {
  return (
    <div>
      <h1>My Page</h1>
      
      {/* Show immediately */}
      <StaticContent />
      
      {/* Stream when ready */}
      <Suspense fallback={<Skeleton />}>
        <SlowComponent />
      </Suspense>
    </div>
  );
}

async function SlowComponent() {
  const data = await slowFetch();
  return <div>{data}</div>;
}
```

### 3. Optimistic Updates with useOptimistic

```tsx
'use client';
import { useOptimistic } from 'react';
import { addTodo } from './actions';

export default function TodoList({ todos }) {
  const [optimisticTodos, addOptimisticTodo] = useOptimistic(
    todos,
    (state, newTodo) => [...state, newTodo]
  );
  
  async function handleSubmit(formData: FormData) {
    const title = formData.get('title') as string;
    
    // Optimistically add todo
    addOptimisticTodo({ id: Date.now(), title, completed: false });
    
    // Actually add todo
    await addTodo(formData);
  }
  
  return (
    <div>
      <form action={handleSubmit}>
        <input name="title" />
        <button type="submit">Add</button>
      </form>
      
      <ul>
        {optimisticTodos.map((todo) => (
          <li key={todo.id}>{todo.title}</li>
        ))}
      </ul>
    </div>
  );
}
```

### 4. Route Handlers for API Endpoints

```tsx
// app/api/webhooks/stripe/route.ts
import { NextRequest } from 'next/server';

export async function POST(request: NextRequest) {
  const body = await request.json();
  
  // Process webhook
  await processStripeWebhook(body);
  
  return Response.json({ received: true });
}

// Rate limiting
export const runtime = 'edge';
export const dynamic = 'force-dynamic';
```

### 5. Middleware for Auth

```tsx
// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const token = request.cookies.get('token');
  
  if (!token && request.nextUrl.pathname.startsWith('/dashboard')) {
    return NextResponse.redirect(new URL('/login', request.url));
  }
  
  return NextResponse.next();
}

export const config = {
  matcher: '/dashboard/:path*',
};
```

---

## 🚀 Performance Optimization

### 1. Image Optimization

```tsx
import Image from 'next/image';

<Image
  src="/hero.jpg"
  alt="Hero"
  width={1920}
  height={1080}
  priority // Load immediately
  placeholder="blur"
  blurDataURL="data:image/jpeg;base64,..."
/>
```

### 2. Font Optimization

```tsx
// app/layout.tsx
import { Inter } from 'next/font/google';

const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-inter',
});

export default function RootLayout({ children }) {
  return (
    <html lang="en" className={inter.variable}>
      <body>{children}</body>
    </html>
  );
}
```

### 3. Bundle Size Optimization

```tsx
// Dynamic imports for large components
import dynamic from 'next/dynamic';

const HeavyChart = dynamic(() => import('./HeavyChart'), {
  loading: () => <p>Loading chart...</p>,
  ssr: false, // Don't render on server
});
```

### 4. Cache Configuration

```tsx
// Revalidate every 60 seconds
export const revalidate = 60;

// Force dynamic (no cache)
export const dynamic = 'force-dynamic';

// Force static (full cache)
export const dynamic = 'force-static';

// Edge runtime
export const runtime = 'edge';
```

---

## 🐛 Troubleshooting

### Issue: "use client" not working

**Solution:**
```tsx
// Must be at the TOP of the file
'use client';

import { useState } from 'react';
// ...
```

### Issue: Server Component in Client Component

**Solution:**
```tsx
// ❌ Don't import
'use client';
import ServerComp from './ServerComp';

// ✅ Pass as prop
'use client';
export default function Client({ children }) {
  return <div>{children}</div>;
}

// Parent (Server Component)
<Client>
  <ServerComp />
</Client>
```

### Issue: Hydration mismatch

**Solution:**
```tsx
// Use suppressHydrationWarning for dynamic content
<time suppressHydrationWarning>
  {new Date().toLocaleString()}
</time>

// Or use useEffect for client-only rendering
'use client';
import { useEffect, useState } from 'react';

export default function ClientTime() {
  const [time, setTime] = useState('');
  
  useEffect(() => {
    setTime(new Date().toLocaleString());
  }, []);
  
  return <time>{time}</time>;
}
```

### Issue: Server Action not working

**Solution:**
```tsx
// Ensure 'use server' is at the top
'use server';

export async function myAction(formData: FormData) {
  // Must be async
  // Must accept FormData or serializable data
}

// In component
<form action={myAction}>
  {/* inputs */}
</form>
```

### Issue: Metadata not updating

**Solution:**
```tsx
// Use generateMetadata for dynamic metadata
export async function generateMetadata({ params }) {
  const data = await fetchData(params.id);
  
  return {
    title: data.title,
    // ...
  };
}

// Not this (static only)
export const metadata = {
  title: 'Static Title',
};
```

---

## 📝 Best Practices Checklist

- [ ] Use Server Components by default
- [ ] Only add `"use client"` when necessary
- [ ] Fetch data in Server Components
- [ ] Use Server Actions for mutations
- [ ] Implement proper error boundaries
- [ ] Add loading states with Suspense
- [ ] Optimize images with next/image
- [ ] Configure proper caching strategies
- [ ] Add metadata for SEO
- [ ] Use TypeScript for type safety
- [ ] Implement proper error handling
- [ ] Test on mobile devices
- [ ] Monitor Core Web Vitals
- [ ] Use Edge Runtime when possible
- [ ] Implement proper security headers

---

## 📚 Additional Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [React Server Components](https://react.dev/blog/2023/03/22/react-labs-what-we-have-been-working-on-march-2023#react-server-components)
- [Server Actions](https://nextjs.org/docs/app/building-your-application/data-fetching/server-actions-and-mutations)
- [Next.js Examples](https://github.com/vercel/next.js/tree/canary/examples)
- [Vercel Analytics](https://vercel.com/analytics)
