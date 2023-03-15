import { AstNode, EmptyFileSystem, LangiumServices } from 'langium';
import { URI } from 'vscode-uri';
import { ExpressionsModel } from '../language-server/generated/ast';
import { createStServices } from '../language-server/st-module';
import { generateJavaScript } from './generator';

export const parseAndGenerate = async (stContent: string): Promise<string> => {
    console.info(stContent);
    const services = createStServices(EmptyFileSystem).St;
    const model = await extractAstNodeFromString<ExpressionsModel>(stContent, services);
    // generate mini logo drawing commands from the model
    const jsonContent = generateJavaScript(model);
    return Promise.resolve(jsonContent);
};

async function extractAstNodeFromString<T extends AstNode>(content: string, services: LangiumServices): Promise<T> {
    const doc = services.shared.workspace.LangiumDocumentFactory.fromString(content, URI.parse('memory://st.document'));
    await services.shared.workspace.DocumentBuilder.build([doc], { validationChecks: 'all' });
    return doc.parseResult?.value as T;
}
