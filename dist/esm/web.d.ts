import { WebPlugin } from '@capacitor/core';
import type { FileSelectOptions, FileSelectPlugin } from './definitions';
export declare class FileSelectWeb extends WebPlugin implements FileSelectPlugin {
    select(options: FileSelectOptions): Promise<any>;
}
