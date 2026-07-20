import { defineConfig } from 'vite';
import { resolve } from 'path';

export default defineConfig({
  build: {
    lib: {
      entry: resolve(__dirname, 'src/index.ts'),
      name: 'AISDKImageGeneration',
      fileName: (format) => `index.${format}.js`,
      formats: ['es']
    },
    rollupOptions: {
      external: [
        'ai',
        '@ai-sdk/openai',
        '@ai-sdk/google',
        '@ai-sdk/xai',
        '@ai-sdk/fal',
        '@fal-ai/client',
        'zod'
      ],
      output: {
        globals: {
          'ai': 'ai',
          '@ai-sdk/openai': 'aiSdkOpenai',
          '@ai-sdk/google': 'aiSdkGoogle',
          '@ai-sdk/xai': 'aiSdkXai',
          '@ai-sdk/fal': 'aiSdkFal',
          '@fal-ai/client': 'falClient',
          'zod': 'zod'
        }
      }
    },
    sourcemap: true,
    minify: false
  },
  test: {
    environment: 'node',
    globals: true,
    setupFiles: ['./tests/setup.ts']
  }
});
