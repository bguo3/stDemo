import { Model } from '../language-server/generated/ast';

export function generateJavaScript(model: Model): string {
    const rungs = model.rungs ;
    console.log(rungs[0])
    const json =`{
        "Rungs": [
            {
                "Rung": [
                    {
                        "TON": "a,b,c"
                    },
                    {
                        "ADD": "var1,var2,var3"
                    }
                ]
            },
            {
                "Rung": [
                    {
                        "XIC": "d",
                        "OTE": "e"
                    }
                ]
            }
        ]
    }`;
    return json ;
}
