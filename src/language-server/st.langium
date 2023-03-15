grammar ST
import "Terminals"

entry ExpressionsModel infers ExpressionsModel:
    elements=Stmt_List  
;

Stmt_List infers Stmt_List:
    (stats+=Stmt )+ 
;

Stmt infers Stmt:
    { infer Stmt} statement=(Expression | Subprog_Ctrl_Stmt | Iteration_Stmt | IF_Stmt | Case_Stmt )? ";"  
;

Iteration_Stmt infers Stmt:
    For_Stmt | While_Stmt | Repeat_Stmt | { infer Stmt} "EXIT"  | { infer Stmt} "CONTINUE"  
;

Repeat_Stmt infers Stmt:
    { infer Repeat_Stmt} "REPEAT" doStmtList=Stmt_List  "UNTIL" until=Expression  "END_REPEAT"  
;

While_Stmt infers Stmt:
    { infer While_Stmt} "WHILE" whileCondition=Expression  "DO" doStmtList=Stmt_List  "END_WHILE"  
;

For_Stmt infers For_Stmt:
    { infer For_Stmt} "FOR" control=Identifier  ":=" forRange=For_List  "DO" doStmtList=Stmt_List  "END_FOR"  
;

For_List infers For_List:
    { infer For_List} from=Expression  "TO" to=Expression  ("BY" by=Expression  )?  
;

Case_Stmt infers Stmt:
    { infer Case_Stmt} "CASE" caseControl=Expression  "OF" caseSelection+=Case_Selection + ("ELSE" caseelsestmtlist=Stmt_List  )? "END_CASE"  
;

Case_Selection infers Case_Selection:
    { infer Case_Selection} caseList=Case_List  ":" caseselectionstmtList=Stmt_List   
;

Case_List infers Case_List:
    { infer Case_List} caseElems+=Case_List_Elem  ("," caseElems+=Case_List_Elem  )*  
;

Case_List_Elem infers Case_List_Elem:
    { infer Case_List_Elem} begin=Constant  (".." end=Constant  )?  
;

IF_Stmt infers Stmt:
    { infer IF_Stmt} "IF" condition=Expression  "THEN" ifthen=Stmt_List  (elseifpart+=Else_If_Part )* (=>"ELSE" elsePart=Stmt_List  )? "END_IF"  
;

Else_If_Part infers Else_If_Part:
    { infer Else_If_Part} "ELSIF" condition=Expression  "THEN" elseifstmt=Stmt_List   
;

Subprog_Ctrl_Stmt infers Stmt:
    { infer Stmt} "RETURN"  
;

Expression infers Expression:
    Assign_Stmt 
;

Assign_Stmt infers Expression:
    Or ({ infer Assignment.left=current} operator=":="  right=Or  )?  
;

Or infers Expression:
    Xor ({ infer Or.left=current} operator="OR"  right=Xor  )*  
;

Xor infers Expression:
    And ({ infer Xor.left=current} operator="XOR"  right=And  )*  
;

And infers Expression:
    Equality ({ infer And.left=current} ("&" | "AND" )right=Equality  )*  
;

Equality infers Expression:
    Comparison ({ infer Equality.left=current} op=("=" | "<>" ) right=Comparison  )*  
;

Comparison infers Expression:
    PlusOrMinus ({ infer Comparison.left=current} op=(">=" | "<=" | ">" | "<" ) right=PlusOrMinus  )*  
;

PlusOrMinus infers Expression:
    MulOrDiv (({ infer PlusOrMinus.left=current} op="+"   | { infer PlusOrMinus.left=current} op="-"   )right=MulOrDiv  )*  
;

MulOrDiv infers Expression:
    Power (({ infer MulOrDiv.left=current} op=("*" | "/" | "MOD" ) ) right=Power  )*  
;

Power infers Expression:
    Unary ({ infer Power.left=current} "**" right=Unary  )*  
;

Unary infers Expression:
    ({ infer Unary_Minus} "-" operand=Primary  ) | ({ infer Unary_Plus} "+" operand=Primary  ) | Primary 
;

Primary infers Expression:
    Constant | { infer Variable_Call} variable=Variable_Access   | FuncCall | "(" Expression ")"  
;

Variable_Access returns string:
    Identifier 
;

FuncCall infers FuncCall:
    { infer FuncCall} funcName=Func_Access  "(" paramList=ParameterList ? ")"  
;

Func_Access infers Func_Access:
    { infer Func_Access} Std_Func_Name  | Pou_Name 
;

Std_Func_Name returns string:
    "TRUNC" | "ABS" | "SQRT" | "LN" | "LOG" | "EXP" | "SIN" | "COS" | "TAN" | "ASIN" | "ACOS" | "ATAN" | "ATAN2" | "ADD" | "SUB" | "MUL" | "DIV" | "MOD" | "EXPT" | "MOVE" | "SHL" | "SHR" | "ROL" | "ROR" | "AND" | "OR" | "XOR" | "NOT" | "SEL" | "MAX" | "MIN" | "LIMIT" | "MUX" | "GT" | "GE" | "EQ" | "LE" | "LT" | "NE" | "LEN" | "LEFT" | "RIGHT" | "MID" | "CONCAT" | "INSERT" | "DELETE" | "REPLACE" | "FIND" 
;

ParameterList infers ParameterList:
    { infer ParameterList} paramAssign+=Expression  ("," paramAssign+=Expression  )*  
;

Pou_Name infers Pou_Name:
    { infer Pou_Name} pouName=Identifier   
;

terminal LETTER returns string:/[a-z]/ | /[A-Z]/ | "_" ;
terminal DIGIT returns string:/[0-9]/ ;
terminal BIT returns string:/[0-1]/ ;
terminal OCTAL__DIGIT returns string:/[0-7]/ ;
terminal Hex_Digit returns string:/[0-9]/ | /[A-F]/ | /[a-f]/ ;
Constant infers Expression:
    { infer Numeric_Literal} constant=Numeric_Literal   | Bit_Str_Literal | Bool_Literal | Time_Literal | Char_Literal 
;

terminal Numeric_Literal returns string:Int_Literal | Real_Literal ;
terminal Int_Literal returns string:((Int_Type_Name "#" )? (Signed_Int | Unsigned_Int | Binary_Int | Octal_Int | Hex_Int )) ;
terminal Unsigned_Int_Terminal returns string:DIGIT ("_"? DIGIT )*  ;
terminal Unsigned_Int returns string:Unsigned_Int_Terminal ;
terminal Signed_Int returns string:("+" | "-" )Unsigned_Int_Terminal  ;
terminal Binary_Int returns string:"2#" ("_"? BIT )+  ;
terminal Octal_Int returns string:"8#" ("_"? OCTAL__DIGIT )+  ;
terminal Hex_Int returns string:"16#" ("_"? Hex_Digit )+  ;
terminal Real_Literal returns string:(Real_Type_Name "#" )? Signed_Int "." Unsigned_Int ("E" Signed_Int )?  ;
terminal Bit_Str_Literal returns string:((Multibits_Type_Name "#" )? (Unsigned_Int | Binary_Int | Octal_Int | Hex_Int )) ;
terminal Bool_Literal returns string:((Bool_Type_Name "#" )? ("0" | "1" | "FALSE" | "TRUE" )) ;
terminal Char_Literal returns string:"STRING#"? Char_Str  ;
terminal Char_Str returns string:S_Byte_Char_Str | D_Byte_Char_Str ;
terminal S_Byte_Char_Str returns string:"\'" S_Byte_Char_Value+ "\'"  ;
terminal D_Byte_Char_Str returns string:"""" D_Byte_Char_Value+ """"  ;//need check
terminal S_Byte_Char_Value returns string:Common_Char_Value | "$\'" | "$" Hex_Digit Hex_Digit  ;//need check
terminal D_Byte_Char_Value returns string:Common_Char_Value | "\'" | "$""" | "$" Hex_Digit Hex_Digit Hex_Digit Hex_Digit  ;//need check
terminal Common_Char_Value returns string:" " | "!" | "#" | "%" | "&" | /[\(-/]/ | /[0-9]/ | /[:-@]/ | /[A-Z]/ | /[\[-`]/ | /[a-z]/ | /[\{-~]/ | "$$" | "$L" | "$N" | "$P" | "$R" | "$T" ;
terminal Time_Literal returns string:Duration | Time_Of_Day | ^Date | Date_And_Time ;
terminal Duration returns string:(Time_Type_Name | "T" | "LT" )"#" ("+" | "-" )?Interval  ;
terminal Fix_Point returns string:Unsigned_Int "." Unsigned_Int  ;
terminal Interval returns string:Days | Hours | Minutes | Seconds | Milliseconds | Microseconds | Nanoseconds ;
terminal Days returns string:(Fix_Point "d" ) | (Unsigned_Int "d" "_"? ) Hours?  ;
terminal Hours returns string:(Fix_Point "h" ) | (Unsigned_Int "h" "_"? ) Minutes?  ;
terminal Minutes returns string:(Fix_Point "m" ) | (Unsigned_Int "m" "_"? ) Seconds?  ;
terminal Seconds returns string:(Fix_Point "s" ) | (Unsigned_Int "s" "_"? ) Milliseconds?  ;
terminal Milliseconds returns string:(Fix_Point "ms" ) | (Unsigned_Int "ms" "_"? ) Microseconds?  ;
terminal Microseconds returns string:(Fix_Point "us" ) | (Unsigned_Int "us" "_"? ) Nanoseconds?  ;
terminal Nanoseconds returns string:Fix_Point "ns"  ;
terminal Time_Of_Day returns string:(Tod_Type_Name | "LTIME_OF_DAY" )"#" Daytime  ;
terminal Daytime returns string:Day_Hour ":" Day_Minute ":" Day_Second  ;
terminal Day_Hour returns string:Unsigned_Int ;
terminal Day_Minute returns string:Unsigned_Int ;
terminal Day_Second returns string:Fix_Point ;
terminal ^Date returns string:(Date_Type_Name | "D" | "LD" )"#" Date_Literal  ;
terminal Date_Literal returns string:Year "-" Month "-" Day  ;
terminal Year returns string:Unsigned_Int ;
terminal Month returns string:Unsigned_Int ;
terminal Day returns string:Unsigned_Int ;
terminal Date_And_Time returns string:(DT_Type_Name | "LDATE_AND_TIME" )"#" Date_Literal "-" Daytime  ;
terminal Int_Type_Name returns string:Sign_Int_Type_Name | Unsign_Int_Type_Name ;
terminal Sign_Int_Type_Name returns string:"SINT" | "INT" | "DINT" | "LINT" ;
terminal Unsign_Int_Type_Name returns string:"USINT" | "UINT" | "UDINT" | "ULINT" ;
terminal Real_Type_Name returns string:"REAL" | "LREAL" ;
terminal Time_Type_Name returns string:"TIME" | "LTIME" ;
terminal Date_Type_Name returns string:"DATE" | "LDATE" ;
terminal Tod_Type_Name returns string:"TIME_OF_DAY" | "TOD" | "LTOD" ;
terminal DT_Type_Name returns string:"DATE_AND_TIME" | "DT" | "LDT" ;
terminal Bool_Type_Name returns string:"BOOL" ;
terminal Multibits_Type_Name returns string:"BYTE" | "WORD" | "DWORD" | "LWORD" ;
terminal Identifier returns string:LETTER (LETTER | DIGIT )* ;
