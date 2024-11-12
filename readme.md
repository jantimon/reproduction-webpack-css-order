# reproduction-webpack-css-order

This repository demonstrates a CSS order issue in Webpack 5 when using a pnpm monorepo with `sideEffects: false` in package.json files.

## The Issue

When `sideEffects: false` is set in package.json files across a monorepo, CSS import order becomes unpredictable.

## References

This bug happens only for webpack 5

The same code works for:

 - [rspack](https://github.com/jantimon/reproduction-webpack-css-order/blob/rspack/)
 - [vite](https://github.com/jantimon/reproduction-webpack-css-order/blob/vite/)
 - [parcel](https://github.com/jantimon/reproduction-webpack-css-order/blob/parcel/)


## Expected Behavior

The css declaration `background-color: orange;` should be the last rule in the CSS file 

- [webpack 5 (broken)](https://github.com/jantimon/reproduction-webpack-css-order/blob/main/%40applications/base/dist/main.css)
- [turbopack (broken)](https://github.com/jantimon/reproduction-webpack-css-order/blob/turbo/%40applications/base/.next/static/chunks/%5Bproject%5D__53bcfa._.css)
- [webpack 5 (sideEffects: true)](https://github.com/jantimon/reproduction-webpack-css-order/blob/side-effects-true/%40applications/base/dist/main.css)
- [webpack 5 (no barrel)](https://github.com/jantimon/reproduction-webpack-css-order/blob/no-barell/%40applications/base/dist/main.css)
- [rspack](https://github.com/jantimon/reproduction-webpack-css-order/blob/rspack/%40applications/base/dist/main.css)
- [vite](https://github.com/jantimon/reproduction-webpack-css-order/blob/vite/%40applications/base/dist/index.css)
- [parcel](https://github.com/jantimon/reproduction-webpack-css-order/blob/parcel/%40applications/base/dist/index.5ff2b6c6.css)


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
The `background-color: orange;` is not the last rule in the CSS file in the [dist](https://github.com/jantimon/reproduction-webpack-css-order/tree/main/%40applications/base/dist) directory:

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
  
1. Change to one of the comparison branches:
   - `side-effects-true` branch: `git checkout side-effects-true` (all packages have `sideEffects: true`)
   - `no-barrel` branch: `git checkout no-barrel` (no barrel file in `@segments/carousel`)

2. Build again
```bash
pnpm build
```

1. See CSS output in `@applications/base/dist`:
 The `background-color: orange;` is now the last rule in the CSS file in the [dist](https://github.com/jantimon/reproduction-webpack-css-order/tree/side-effects-true/%40applications/base/dist) directory:


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

## Module Graphs

```mermaid
graph TD
    subgraph "sideEffects: false"
        A1["@applications/base/src/index.ts preOrder: 0, postOrder: 6"]
        B1["@libraries/teaser/src/teaser.ts preOrder: 1, postOrder: 5"]
        C1["@libraries/teaser/src/teaser.module.css preOrder: 2, postOrder: 1"]
        D1["teaser.module.css|0|||}} preOrder: 3, postOrder: 0"]
        E1["@segments/carousel/src/buttons.ts preOrder: 4, postOrder: 4"]
        F1["@segments/carousel/src/button.module.css preOrder: 5, postOrder: 3"]
        G1["button.module.css|0|||}} preOrder: 6, postOrder: 2"]
        
        A1 --> B1
        B1 --> C1
        C1 --> D1
        B1 --> E1
        E1 --> F1
        F1 --> G1

        style A1 fill:#0a0a4a,stroke:#333
        style C1 fill:#294b51,stroke:#333
        style D1 fill:#294b51,stroke:#333
        style F1 fill:#294b51,stroke:#333
        style G1 fill:#294b51,stroke:#333
    end

    subgraph "sideEffects: true"
        A2["@applications/base/src/index.ts preOrder: 0, postOrder: 8"]
        B2["@libraries/teaser/src/index.ts preOrder: 1, postOrder: 7"]
        C2["@libraries/teaser/src/teaser.ts preOrder: 2, postOrder: 6"]
        D2["@segments/carousel/src/index.ts preOrder: 3, postOrder: 3"]
        E2["@segments/carousel/src/buttons.ts preOrder: 4, postOrder: 2"]
        F2["@segments/carousel/src/button.module.css preOrder: 5, postOrder: 1"]
        G2["button.module.css|0|||}} preOrder: 6, postOrder: 0"]
        H2["@libraries/teaser/src/teaser.module.css preOrder: 7, postOrder: 5"]
        I2["teaser.module.css|0|||}} preOrder: 8, postOrder: 4"]
        
        A2 --> B2
        B2 --> C2
        C2 --> D2
        D2 --> E2
        E2 --> F2
        F2 --> G2
        C2 --> H2
        H2 --> I2

        style A2 fill:#0a0a4a,stroke:#333
        style F2 fill:#294b51,stroke:#333
        style G2 fill:#294b51,stroke:#333
        style H2 fill:#294b51,stroke:#333
        style I2 fill:#294b51,stroke:#333
    end

    subgraph "No Barrel"
        A3["@applications/base/src/index.ts preOrder: 0, postOrder: 6"]
        B3["@libraries/teaser/src/teaser.ts preOrder: 1, postOrder: 5"]
        E3["@segments/carousel/src/buttons.ts preOrder: 2, postOrder: 2"]
        F3["@segments/carousel/src/button.module.css preOrder: 3, postOrder: 1"]
        G3["button.module.css|0|||}} preOrder: 4, postOrder: 0"]
        H3["@libraries/teaser/src/teaser.module.css preOrder: 5, postOrder: 4"]
        I3["teaser.module.css|0|||}} preOrder: 6, postOrder: 3"]
        
        A3 --> B3
        B3 --> E3
        E3 --> F3
        F3 --> G3
        B3 --> H3
        H3 --> I3
        style A3 fill:#0a0a4a,stroke:#333
        style F3 fill:#294b51,stroke:#333
        style G3 fill:#294b51,stroke:#333
        style H3 fill:#294b51,stroke:#333
        style I3 fill:#294b51,stroke:#333
    end
```