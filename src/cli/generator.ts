import { Model } from '../language-server/generated/ast';

export function generateJavaScript(model: Model): string {
    console.log('generateJavaScript 1')
    const persons = model.persons ;
    console.log(persons[0])
    console.log('generateJavaScript 2')
    return persons[0].name;
}
