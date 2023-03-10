/******************************************************************************
 * This file was generated by langium-cli 1.0.0.
 * DO NOT EDIT MANUALLY!
 ******************************************************************************/

import { LangiumGeneratedServices, LangiumGeneratedSharedServices, LangiumSharedServices, LangiumServices, LanguageMetaData, Module } from 'langium';
import { StAstReflection } from './ast';
import { StGrammar } from './grammar';

export const StLanguageMetaData: LanguageMetaData = {
    languageId: 'st',
    fileExtensions: ['.st'],
    caseInsensitive: false
};

export const StGeneratedSharedModule: Module<LangiumSharedServices, LangiumGeneratedSharedServices> = {
    AstReflection: () => new StAstReflection()
};

export const StGeneratedModule: Module<LangiumServices, LangiumGeneratedServices> = {
    Grammar: () => StGrammar(),
    LanguageMetaData: () => StLanguageMetaData,
    parser: {}
};
