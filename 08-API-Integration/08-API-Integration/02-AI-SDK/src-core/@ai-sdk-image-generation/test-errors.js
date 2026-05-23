// Quick test to see actual error messages
import { validateAndNormalizeRequest } from './src/utils/validation.js';

console.log('Testing unsupported provider:');
const result = validateAndNormalizeRequest({ prompt: 'Test', provider: 'unsupported' });
console.log('Errors:', result.errors);
