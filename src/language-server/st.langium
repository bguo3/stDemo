grammar Ascii




entry Model:

    rungs+=Rung*;

 

// NewRung:

//     return = RETURN;

Rung:

    instrunctions += InstructionStatement* RETURN;




InstructionStatement:

    instructionStatement = (FunctionCall | UnknownFunctionCall | BranchStatement);




FunctionCall:

    name = FunctionName params =ParameterList;




FunctionName:

    name=("TON"|"CTU"|"ADD"|"XIC"|"OTE" |Operator);




ParameterList:

    parameterList += Parameter*;




Parameter:

    param = (VariableAccess |ConstantParameter);




VariableAccess:

    name = ID; // need to do further change




ConstantParameter:

    constParameter =  INT; // need to further change




BranchStatement:

    'BST' function = FunctionCall* subBranch=SubBranchStatement+ function2 = FunctionCall* 'BND'; //need to handle nested branches, cannot just put BranchState here to avoid infinite loop which caused by left recursive




SubBranchStatement:

    'NXB' function =FunctionCall* branch=BranchStatement*;




UnknownFunctionCall:

  'UNK' unknownFuction = STRING; // need to change





//hidden terminal WS: /\s+/;

hidden terminal WS: /[ \t\r]+/;

terminal ID: /[_a-zA-Z][\w_]*/;

terminal INT returns number: /[0-9]+/;

terminal STRING: /"[^"]*"|'[^']*'/;

terminal Operator: /"+-*\/"/;

terminal RETURN: /\r?\n/;

//terminal FunctionNameList: /'TON'|'CTU'|'ADD'|'XIC'|'OTE'/;




hidden terminal ML_COMMENT: /\/\*[\s\S]*?\*\//;

hidden terminal SL_COMMENT: /\/\/[^\n\r]*/;