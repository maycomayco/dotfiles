# React + TypeScript Development Rules

## 🏗️ Component Architecture

### Structure
- Create small, composable components
- One component per file to avoid breaking hot reloading
- Never use class components
- Use container/presentational pattern: container components handle hooks and state, presentational components only receive props
- Prepare for server components by limiting hook usage
- Avoid framework-specific features
- Do not import "React" in every file

### Data Flow
- Prefer props and top-down data flow
- Use callbacks through props
- Use Jotai atoms sparingly, only in container components
- Pass atom values as props to children instead of accessing atoms directly
- Limit atom usage to container components

## 📝 TypeScript Rules

### Strict Types
- Never use `any`
- Never use type casting or `as`
- Never use `@ts-expect-error` outside of unit tests
- Use `readonly` properties in object types by default
- Omit `readonly` only when property is genuinely mutable

### Imports
- Use `import type` when importing types
- Prefer top-level `import type` over inline `import { type ... }`

### Type Annotations
- Exported functions need explicit return types
- React components do not need explicit return types
- Type arrays correctly using fixed-length arrays and non-empty array types when possible

### Error Handling and Optional Values
- Create Zod schemas for `any` or `unknown` data
- Never use type casting to solve type errors
- Use Option instead of `null` or `undefined`
- Use Either instead of throwing errors

### Functional Programming
- Do not use switches or complex if/else statements, use ts-pattern library
- All functions, hooks, and components must be single-purpose
- Compose at higher levels using pipe or flow from fp-ts

### Type Design
- Prefer tagged unions over objects with optional fields
- Follow "Domain Driven Design Made Functional" for new features

### Type Design
- Prefer tagged unions over objects with optional fields
- Follow "Domain Driven Design Made Functional" for new features

## 🎨 Styling

### Type Design
- Prefer tagged unions over objects with optional fields
- Follow "Domain Driven Design Made Functional" for new features

### Documentation
- Add a JSDoc comment (`/** ... */`) above every component defined locally in the file
- The comment should briefly describe what the component does, its main purpose, and any important details that help other developers understand it quickly
- Add JSDoc property comment (`/** ... */`) above each property in types or interfaces to describe their purpose
- Keep property comments in only one line
- JSDoc comments help TypeScript, editors (like VSCode), and tools (like TypeDoc) show tooltips, autocomplete hints, and generate documentation

## 🎨 Styling

### Tailwind CSS
- Use Tailwind classes for styling
- Avoid arbitrary classes
- Replace arbitrary classes in files you are working on

## 🚫 Prohibitions

- Do not use class components
- Do not use Gatsby features
- Do not use `any` type
- Do not use type casting (`as`)
- Do not use `@ts-expect-error` (except in tests)
- Do not use `null` or `undefined` (use Option)
- Do not throw errors (use Either)
- Do not use switches or complex if/else statements (use ts-pattern)
- Do not use arbitrary CSS classes