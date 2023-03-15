import { ExpressionsModel } from '../language-server/generated/ast';

export function generateJavaScript(model: ExpressionsModel): string {
    console.log('generateJavaScript 1')
    const persons = model.elements ;
    console.log(persons)
    console.log('generateJavaScript 2')
    return "";
}
