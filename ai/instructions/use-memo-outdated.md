# React Performance Optimization: useMemo, useCallback, and React.memo

## General Philosophy

**Don't optimize prematurely.** Only use these hooks when you have:

1. Measured performance issues
2. Identified the specific bottleneck
3. Confirmed the optimization actually helps

React is fast by default. Most components don't need memoization.

## useMemo

#### When to Use

- **Expensive calculations**: Complex computations that take noticeable time (>5ms)
- **Reference stability**: When child components/hooks depend on object/array references
- **Large data transformations**: Filtering, mapping, or sorting large datasets

### When NOT to Use

- Simple calculations or primitive values
- Objects/arrays that are already wrapped in useMemo/useState
- Values that change on every render anyway
- To wrap every single computation "just in case"

### Examples

**❌ BAD - Unnecessary useMemo:**

```typescript
// Primitives don't need memoization
const doubled = useMemo(() => count * 2, [count]);

// Simple object creation - not worth it
const config = useMemo(() => ({ enabled: true }), []);

// Already stable from useState
const [user, setUser] = useState({});
const userMemo = useMemo(() => user, [user]); // Redundant!
```

**✅ GOOD - Justified useMemo:**

```typescript
// Expensive calculation
const sortedAndFilteredItems = useMemo(() => {
  return items
    .filter((item) => item.price > 100)
    .sort((a, b) => b.price - a.price);
}, [items]);

// Reference stability for useEffect dependency
const config = useMemo(
  () => ({
    apiKey: process.env.API_KEY,
    timeout: 5000,
  }),
  []
);

useEffect(() => {
  fetchData(config);
}, [config]); // Won't re-run unnecessarily
```

**❌ ANTI-PATTERN - Double wrapping:**

```typescript
const value = useMemo(() => computeValue(data), [data]);

// This second useMemo adds NO value
return useMemo(() => ({ value }), [value]);

// Just return the object directly:
return { value };
```

## Rules of Thumb

1. **Measure first, optimize second**: Use React DevTools Profiler
2. **One memoization level**: Don't wrap memoized values in more memoization
3. **Check dependencies**: Ensure dependency arrays are correct
4. **Consider alternatives**: Sometimes restructuring components is better
5. **Stay consistent**: If using memo on parent, use useCallback for callbacks passed to it

## Common Mistakes

### ❌ Memoizing everything

```typescript
// This is over-engineering
const Component = () => {
  const a = useMemo(() => 1 + 1, []);
  const b = useMemo(() => a + 1, [a]);
  const c = useMemo(() => b + 1, [b]);
  return <div>{c}</div>;
};
```

### ❌ Wrong dependencies

```typescript
// Missing dependency - will use stale value
const value = useMemo(() => {
  return compute(data, filter);
}, [data]); // Missing 'filter'!
```

### ❌ Memoizing with unstable dependencies

```typescript
// config changes every render, so useMemo is useless
const result = useMemo(() => {
  return processData(data);
}, [data, { config: true }]); // Object literal changes every render!
```

## When in Doubt

**Start without memoization.** Add it only when you:

- See slow renders in React DevTools Profiler
- Have components re-rendering unnecessarily
- Are working with large datasets (>1000 items)

Remember: Premature optimization is the root of all evil. Clear, readable code > micro-optimizations.
