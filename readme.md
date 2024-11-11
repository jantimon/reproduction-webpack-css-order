# reproduction-webpack-css-order

This repository demonstrates a CSS order issue in Webpack 5 when using a pnpm monorepo with `sideEffects: false` in package.json files.

## The Issue

When `sideEffects: false` is set in package.json files across a monorepo, CSS import order becomes unpredictable.

## Steps to Reproduce

1. Clone the repository
```bash
git clone https://github.com/jantimonpn/reproduction-webpack-css-order.git
cd reproduction-webpack-css-order
```

2. Install dependencies
```bash
pnpm install
```

3. Build 
```bash
pnpm build
```

4. See CSS output in `@applications/base/dist`:
The `background-color: orange;` is not the last rule in the CSS file:

```css
.hDE5PT5V3QGAPX9o9iZl {
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 8px;
  margin: 16px;
}

.yqrxTjAG22vkATE1VjR9 {
  background-color: orange;
}

.R_y25aX9lTSLQtlxA1c9 {
  padding: 8px 16px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
}
```
  
5. Replace `"sideEffects": false` with `"sideEffects": true` in all `package.json` files
(or switch to the `side-effects-true` branch)
```bash
git checkout -b side-effects-true
```


6. Build again
```bash
pnpm build
```

7. See CSS output in `@applications/base/dist`:
 The `background-color: orange;` is now the last rule in the CSS file


```css
.R_y25aX9lTSLQtlxA1c9 {
  padding: 8px 16px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
}

.hDE5PT5V3QGAPX9o9iZl {
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 8px;
  margin: 16px;
}

.yqrxTjAG22vkATE1VjR9 {
  background-color: orange;
}
```

## Project Structure

```
├── @applications/base
├── @libraries/teaser
└── @segments/carousel
```

Each package has `sideEffects: false` in its package.json, which triggers the issue.

## Environment

- Webpack 5
- pnpm
- Node.js >= 20
- All packages have `sideEffects: false`