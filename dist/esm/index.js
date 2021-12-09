import { registerPlugin } from '@capacitor/core';
const FileSelect = registerPlugin('FileSelect', {
    web: () => import('./web').then(m => new m.FileSelectWeb()),
});
export * from './definitions';
export { FileSelect };
//# sourceMappingURL=index.js.map