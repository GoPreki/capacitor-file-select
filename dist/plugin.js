var capacitorFileSelect = (function (exports, core) {
    'use strict';

    const FileSelect = core.registerPlugin('FileSelect', {
        web: () => Promise.resolve().then(function () { return web; }).then(m => new m.FileSelectWeb()),
    });

    class FileSelectWeb extends core.WebPlugin {
        async select(options) {
            const x = document.createElement('INPUT');
            x.hidden = true;
            x.setAttribute('type', 'file');
            x.setAttribute('id', 'filePicker');
            let accept = '';
            options.extensions.forEach(element => {
                if (element == 'images') {
                    accept = accept.concat('image/*,');
                }
                else if (element == 'videos') {
                    accept = accept.concat('video/*,');
                }
                else if (element == 'audios') {
                    accept = accept.concat('audio/*,');
                }
            });
            let index = options.extensions.indexOf('images');
            if (index > -1) {
                options.extensions.splice(index, 1);
            }
            index = options.extensions.indexOf('videos');
            if (index > -1) {
                options.extensions.splice(index, 1);
            }
            index = options.extensions.indexOf('audios');
            if (index > -1) {
                options.extensions.splice(index, 1);
            }
            options.extensions = options.extensions.map(v => '.' + v);
            accept = accept.concat(options.extensions.join(','));
            x.setAttribute('accept', accept);
            if (options.multiple) {
                x.setAttribute('multiple', 'true');
            }
            return new Promise(resolve => {
                x.addEventListener('change', () => {
                    if (document != null) {
                        resolve(x.files);
                    }
                });
                x.click();
            });
        }
    }

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        FileSelectWeb: FileSelectWeb
    });

    exports.FileSelect = FileSelect;

    Object.defineProperty(exports, '__esModule', { value: true });

    return exports;

}({}, capacitorExports));
//# sourceMappingURL=plugin.js.map
