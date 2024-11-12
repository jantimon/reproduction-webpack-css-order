import { defineConfig } from 'vite';
import swc from 'vite-plugin-swc';

export default defineConfig({
  plugins: [swc()],
  build: {
    outDir: 'dist',
    rollupOptions: {
      output: {
        entryFileNames: '[name].js',
        assetFileNames: '[name].[ext]'
      }
    }
  },
  css: {
    modules: {
      localsConvention: 'camelCase'
    }
  }
});