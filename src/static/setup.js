import { MonacoEditorLanguageClientWrapper, vscode } from "./monaco-editor-wrapper/index.js";
import { buildWorkerDefinition } from "./monaco-editor-workers/index.js";

buildWorkerDefinition(
  "./monaco-editor-workers/workers",
  new URL("", window.location.href).href,
  false
);

MonacoEditorLanguageClientWrapper.addMonacoStyles("monaco-editor-styles");

const client = new MonacoEditorLanguageClientWrapper();
const editorConfig = client.getEditorConfig();
editorConfig.setMainLanguageId("st");

editorConfig.setMonarchTokensProvider( {keywords: [
  'ADD','BND','BST','CTU','NXB','OTE','TON','UNK','XIC'
],
operators: [

],
symbols: '',

tokenizer: {
  initial: [
      { regex: /[_a-zA-Z][\w_]*/, action: { cases: { '@keywords': {"token":"keyword"}, '@default': {"token":"ID"} }} },
      { regex: /[0-9]+/, action: {"token":"number"} },
      { regex: /"[^"]*"|'[^']*'/, action: {"token":"string"} },
      { regex: /"+-*\/"/, action: {"token":"Operator"} },
      { regex: /\r?\n/, action: {"token":"RETURN"} },
      { include: '@whitespace' },
      { regex: /@symbols/, action: { cases: { '@operators': {"token":"operator"}, '@default': {"token":""} }} },
  ],
  whitespace: [
      { regex: /[ \t\r]+/, action: {"token":"white"} },
      { regex: /\/\*/, action: {"token":"comment","next":"@comment"} },
      { regex: /\/\/[^\n\r]*/, action: {"token":"comment"} },
  ],
  comment: [
      { regex: /[^\/\*]+/, action: {"token":"comment"} },
      { regex: /\*\//, action: {"token":"comment","next":"@pop"} },
      { regex: /[\/\*]/, action: {"token":"comment"} },
  ],
}});

// editorConfig.setMainCode(`
// person Aaa
// Hello Aaa!
// `);

editorConfig.setMainCode(`

//Please hit enter when you finish one rung

BST TON a b c NXB ADD var1 var2 var3 BND

XIC d OTE e




`);
editorConfig.theme = "vs-dark";
editorConfig.useLanguageClient = true;
editorConfig.useWebSocket = false;

const workerURL = new URL("./st-server-worker.js", import.meta.url);
console.log(workerURL.href);

const lsWorker = new Worker(workerURL.href, {
  type: "classic",
  name: "ST Language Server",
});
client.setWorker(lsWorker);

// keep a reference to a promise for when the editor is finished starting, we'll use this to setup the canvas on load
const startingPromise = client.startEditor(
  document.getElementById("monaco-editor-root")
);

let running = false;
const generateAndDisplay = (() => {
    if (running) {
        return;
    }
    running = true;
    const value = client.editor.getValue();
    if (window.localStorage) {
        window.localStorage.setItem('mainCode', value);
    }
    // execute custom command, and receive the response
    vscode.commands.executeCommand('generateStJson', value).then((stJson) => {
      console.info(stJson);
    }).catch((e) => {
      console.error(e);
    }).finally(() => {
        running = false;
    });
});

// Updates the mini-logo canvas
window.generateAndDisplay = generateAndDisplay;