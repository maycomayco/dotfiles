# Testing Guide

## How to Write Tests

Based on the Guiding Principles, your test should resemble how users interact with your code (component, page, etc.) as much as possible. With this in mind, we recommend this order of priority:

### Queries Accessible to Everyone
Queries that reflect the experience of visual/mouse users as well as those that use assistive technology.

- `getByRole`: This can be used to query every element that is exposed in the accessibility tree. With the `name` option you can filter the returned elements by their accessible name. This should be your top preference for just about everything. There's not much you can't get with this (if you can't, it's possible your UI is inaccessible). Most often, this will be used with the name option like so: `getByRole('button', {name: /submit/i})`. Check the list of roles.
- `getByLabelText`: This method is really good for form fields. When navigating through a website form, users find elements using label text. This method emulates that behavior, so it should be your top preference.
- `getByPlaceholderText`: A placeholder is not a substitute for a label. But if that's all you have, then it's better than alternatives.
- `getByText`: Outside of forms, text content is the main way users find elements. This method can be used to find non-interactive elements (like divs, spans, and paragraphs).
- `getByDisplayValue`: The current value of a form element can be useful when navigating a page with filled-in values.

### Semantic Queries
HTML5 and ARIA compliant selectors. Note that the user experience of interacting with these attributes varies greatly across browsers and assistive technology.

- `getByAltText`: If your element is one which supports alt text (img, area, input, and any custom element), then you can use this to find that element.
- `getByTitle`: The title attribute is not consistently read by screenreaders, and is not visible by default for sighted users

### Test IDs
- `getByTestId`: The user cannot see (or hear) these, so this is only recommended for cases where you can't match by role or text or it doesn't make sense (e.g. the text is dynamic).

## Testing Rules

- Before making or suggesting any changes, please highlight which requirements do not align with the defined rules.
- Always run axe to check for accessibility (a11y) issues.
- Avoid writing multiple tests that render a component with the same props; a single test is enough to check if it renders correctly or has no accessibility (a11y) violations.
- If a prop (like an array) can have different values that affect rendering or behavior, it's valid to render the component multiple times with those variations to cover those scenarios.
- Prefer using `userEvent()` over `fireEvent()` when simulating user interactions. `userEvent.click` is already wrapped in `act` by default and better reflects real user behavior, including focus changes, key events, and timing. For more context, check the official guide: https://testing-library.com/docs/guide-events/#interactions-vs-events
- Vitest functions are globally available in our environment, so manual imports like `import { describe, it, vi } from 'vitest'` are unnecessary.
  - This rule does **not** apply to `@testing-library`: always add explicit imports for functions and utilities from `@testing-library/react` or related packages.
- Within a `describe()` block, use `it()` for consistency. Outside of `describe()`, always use `test()`.
- Follow ARRANGE/ACT/ASSERT pattern
- Simulate real user interactions
- Use accessible queries: `aria-label`, `alt`, `role`, visible labels
  - Avoid `data-testid` unless absolutely needed
- Only tell me **which rule is not being followed**, in a concise way, so I can guide another developer to fix it.
- Do **not** explain why or whether the other rules are followed.
- Make the answer short and efficient to save tokens and improve response speed.
- Using container is an anti-pattern. [https://kentcdodds.com/blog/common-mistakes-with-react-testing-library#not-using-screen]

## Reference
[https://testing-library.com/docs/queries/about]
