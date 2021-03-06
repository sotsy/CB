// A compiler that translates alg30 programs into Jasmin (Java assemble-> Nr).
// The symbol table is created after parsing (not during parsing).
// Variables may be used before they are declared.

root
  root1() // "with    bells and whistles" for development
  // root2() // "without bells and whistles" for test and production

proc    root1()
  rule  root1()
        initialise()
        "-------------------------------\n"
        "Error messages from the parser:\n"
        CS_Cmds(-> SynTree)
        "No errors found!\n"
        "-------------------------------\n"
        "Additional error messages:\n"
        check10(SynTree)
        "No additonal error messages\n"
        "-------------------------------\n"
        "SynTree:\n" pCmds(SynTree)
        "-------------------------------\n"
        // Translate the SynTree and output the result to a .j file:
        outAll(SynTree)

proc    root2()
  rule  root2()
        initialise()
        CS_Cmds(-> SynTree)
        check10(SynTree)
        outAll(SynTree)

// Global variables ////////////////////////////////////////////////////////////

// Each source identifier has to be translated to a target identifier:
// Target identifiers are natural numbers starting with 1.
data NextTargetID(-> int)
data Iterator(-> int)
data LabelIterator(-> int)

// The symbol table SymTab maps source identifiers of type string
// to their meaning of type Meaning
type Meaning m(Type:AS_Type, TargetID:int)
data SymTab(string -> Meaning)

// Global variables have to be initialized before they are used:
proc    initialise()
  rule  initialise()
        Set-NextTargetID(1)
        Set-Iterator(1)
        Set-LabelIterator(1)

// Abstract syntax types ///////////////////////////////////////////////////////

type AS_Cmd
  read(SI:string)
  write(AS_Exp)
  writeln(AS_Exp)
  vardec(SI:string, AS_Type, AS_Exp)
  assign(SI:string, AS_Exp)

type AS_Exp
  lit(AS_Val)                   // Literal
  varapp(string)                // Variable applied
  exp1(AS_Op1, AS_Exp)          // Expression with unary  operator
  exp2(AS_Op2, AS_Exp, AS_Exp)  // Expression with binary operator

type AS_Val
  stringVal(string)
  intVal(int)
  boolVal(int)

type AS_Type
  int()
  bool()
  string()

type AS_Op1
  minus()
  not()

type AS_Op2
  add()   // +
  and()   // and
  conc()  // &
  div()   // /
  eq()    // =
  ge()    // >=
  gt()    // >
  le()    // <=
  lt()    // <
  mul()   // *
  ne()    // !=
  or()    // or
  sub()   // -

// Concrete syntax to abstract syntax (syntax checks of type 3 and 2) //////////

// An alg source program has to contain at least one command
phrase  CS_Cmds(-> AS_Cmd[])
  rule  CS_Cmds(-> AS_Cmd[ACMD])
        CS_Cmd (-> ACMD) ";"
  rule  CS_Cmds(-> AS_Cmd[ACMD::ACMDS])
        CS_Cmd (-> ACMD) ";"
        CS_Cmds(-> ACMDS)

// - Parse commands like read, write and writeln
// - Variable declarations without explicit initialization. Such Variables
//   will implicitly be initialized with 0 or "" respectively
// - Variable declarations with explicit initialization
phrase  CS_Cmd(-> AS_Cmd)
  rule  CS_Cmd(-> read(SI))     : "read"    "(" CS_Ident(-> SI) ")"
  rule  CS_Cmd(-> write(EXP))   : "write"   "(" CS_Exp(-> EXP)  ")"
  rule  CS_Cmd(-> writeln(EXP)) : "writeln" "(" CS_Exp(-> EXP)  ")"
  rule  CS_Cmd(-> vardec(SI,   bool(), lit(boolVal(0))))
        "bool"   CS_Ident(-> SI)
  rule  CS_Cmd(-> vardec(SI,    int(), lit(intVal(0))))
        "int"    CS_Ident(-> SI)
  rule  CS_Cmd(-> vardec(SI, string(), lit(stringVal(""))))
        "string" CS_Ident(-> SI)
  rule  CS_Cmd(-> vardec(SI,   bool(), EXP))
        "bool"   CS_Ident(-> SI) ":=" CS_Exp(-> EXP)
  rule  CS_Cmd(-> vardec(SI,    int(), EXP))
        "int"    CS_Ident(-> SI) ":=" CS_Exp(-> EXP)
  rule  CS_Cmd(-> vardec(SI, string(), EXP))
        "string" CS_Ident(-> SI) ":=" CS_Exp(-> EXP)
  rule  CS_Cmd(-> assign(SI, EXP)) : CS_Ident(-> SI) ":=" CS_Exp(-> EXP)

phrase  CS_Exp (-> AS_Exp)
  rule  CS_Exp (-> exp2(conc(), E1, E2)) : CS_Exp(-> E1) "&" CS_Exp1(-> E2)
  rule  CS_Exp (-> EXP) : CS_Exp1(-> EXP)

phrase  CS_Exp1(-> AS_Exp)
  rule  CS_Exp1(-> exp2(lt(), E1, E2))  : CS_Exp1(-> E1) "<"  CS_Exp2(-> E2)
  rule  CS_Exp1(-> exp2(le(), E1, E2))  : CS_Exp1(-> E1) "<=" CS_Exp2(-> E2)
  rule  CS_Exp1(-> exp2(ne(), E1, E2))  : CS_Exp1(-> E1) "!=" CS_Exp2(-> E2)
  rule  CS_Exp1(-> exp2(ge(), E1, E2))  : CS_Exp1(-> E1) ">=" CS_Exp2(-> E2)
  rule  CS_Exp1(-> exp2(gt(), E1, E2))  : CS_Exp1(-> E1) ">"  CS_Exp2(-> E2)
  rule  CS_Exp1(-> exp2(eq(), E1, E2))  : CS_Exp1(-> E1) "="  CS_Exp2(-> E2)
  rule  CS_Exp1(-> EXP) : CS_Exp2(-> EXP)

phrase  CS_Exp2(-> AS_Exp)
  rule  CS_Exp2(-> exp2(or(), E1, E2))  : CS_Exp2(-> E1) "or" CS_Exp3(-> E2)
  rule  CS_Exp2(-> EXP) : CS_Exp3(-> EXP)

phrase  CS_Exp3(-> AS_Exp)
  rule  CS_Exp3(-> exp2(and(), E1, E2)) : CS_Exp3(-> E1) "and" CS_Exp4(-> E2)
  rule  CS_Exp3(-> EXP) : CS_Exp4(-> EXP)

phrase  CS_Exp4(-> AS_Exp)
  rule  CS_Exp4(-> exp1(not(), EXP))    : "not" CS_Exp5(-> EXP)
  rule  CS_Exp4(-> EXP) : CS_Exp5(-> EXP)

phrase  CS_Exp5(-> AS_Exp)
  rule  CS_Exp5(-> exp2(add(), E1, E2)) : CS_Exp5(-> E1) "+" CS_Exp6(-> E2)
  rule  CS_Exp5(-> exp2(sub(), E1, E2)) : CS_Exp5(-> E1) "-" CS_Exp6(-> E2)
  rule  CS_Exp5(-> EXP) : CS_Exp6(-> EXP)

phrase  CS_Exp6(-> AS_Exp)
  rule  CS_Exp6(-> exp2(mul(), E1, E2)) : CS_Exp6(-> E1) "*" CS_Exp7(-> E2)
  rule  CS_Exp6(-> exp2(div(), E1, E2)) : CS_Exp6(-> E1) "/" CS_Exp7(-> E2)
  rule  CS_Exp6(-> EXP) : CS_Exp7(-> EXP)

phrase  CS_Exp7(-> AS_Exp)
  rule  CS_Exp7(-> exp1(minus(), EXP))  : "-" CS_Exp8(-> EXP)
  rule  CS_Exp7(-> EXP) : CS_Exp8(-> EXP)

// Parse expressions like strings, booleans, ints and identifiers
phrase  CS_Exp8(-> AS_Exp)
  rule  CS_Exp8(-> EXP)                 : "(" CS_Exp(-> EXP) ")"
  rule  CS_Exp8(-> lit(stringVal(STR))) : CS_String(-> STR)
  rule  CS_Exp8(-> lit(intVal(INT)))    : CS_Natural(-> INT)
  rule  CS_Exp8(-> lit(boolVal(0)))     : "false"
  rule  CS_Exp8(-> lit(boolVal(1)))     : "true"
  rule  CS_Exp8(-> varapp(SI))          : CS_Ident(-> SI)

// Gentle has predefined token predicates IDENT, INTEGER and STRING,
// but here we define our own to see how it can be done:
token CS_Ident(-> string)
  <<<[A-Za-z](_?[A-Za-z0-9])*>>>

token CS_Natural(-> int)
  <<<[0-9]+>>>

// The double quotes around a string literal (e.g. "Hello") are only
// concrete syntax, but do not belong to the value of the literal.
// Therefore they have to be removed with a Value Converter For Tokens:
token CS_String(-> string)
  <<<\"([^\"]|\\\")*\">>>
  with RemoveQuotes

// Removes the first and the last char from s1 to get s2
proc    RemoveQuotes(s1:string -> s2:string) // A Value Converter For Tokens
  rule  RemoveQuotes(Str -> Substr)
        Stringlength(Str -> Len)
        Substring(Str, 1, Len-1 -> Substr)

// Combining the following 3 whitespace definitions into 1 is possible,
// but may decrease readability.

// Comments starting with // and extending to the end of the current line
// The dot . matches any character except newline \n
whitespace
  <<<//.*>>>

// Comments starting and ending with #. Several such comments may appear
// on the same line and one such comment may span several lines.
// [^#] matches any character except # (but including newline \n)
whitespace
  <<<#[^#]+#>>>

// The above whitespace definitions switch off the standard definition.
// Therefore here we add spaces, tabs \t, newlines \n and
// carriage returns \r to the whitespace lexems:
whitespace
  <<<(\ |\t|\n|\r)>>>

////////////////////////////////////////////////////////////////////////////////

// Check for formal errors which the lexer and parser could not detect
// ("semantic errors" or "errors of type 1 and type 0")
// After finding and reporting the first such error this compiler will stop.
proc    check10(SynTree: AS_Cmd[])
  rule  check10(CMDS):
        checkVarDecls(CMDS)       // Is no variable declared more than once?
        checkVarApplsInCmds(CMDS) // Is every applied variable declared?

// From a syntax tree construct a symbol table and
// check for double declarations:
proc    checkVarDecls(SynTree:AS_Cmd[])
  // Variable declarations are processed
  rule  checkVarDecls(AS_Cmd[])
  rule  checkVarDecls(AS_Cmd[vardec(ID, _, _)::CMDS]):
        Get-SymTab(ID -> _)
        sourcepos(ID -> POS)
        error "double declaration", POS
  rule  checkVarDecls(AS_Cmd[vardec(ID, T, EXP)::CMDS]):
        Get-NextTargetID(-> N)
        {
          T -> bool()
          isBool(EXP)
        |
          T -> int()
          isInt(EXP)
        |
          T -> string()
          isString(EXP)
        |
          sourcepos(ID -> POS)
          // "Error in line " $POS ": " $ID " is from type " pTypeFromExp(EXP) ". EXPECTED: " pType(T) "\n"
          error "unexpected type", POS
        }
        Set-SymTab(ID, m(T, N))
        Set-NextTargetID(N+1)
        // "  declare " $ID " as " pType(T) " [" $N "]\n"
        checkVarDecls(CMDS)
  // Commands other than variable declarations are skipped
  rule  checkVarDecls(AS_Cmd[CMD::CMDS]):
        checkVarDecls(CMDS)
  rule  checkVarDecls(AS_Cmd[])

// Check whether all variables applied in a list of commands have been declared
proc    checkVarApplsInCmds(SynTree:AS_Cmd[])
  rule  checkVarApplsInCmds(AS_Cmd[CMD::CMDS]):
        checkVarApplsInCmds(CMDS)
        checkVarApplsInCmd (CMD)
  rule  checkVarApplsInCmds(AS_Cmd[]):

// Check whether all variables applied in a single command have been declared
proc    checkVarApplsInCmd(AS_Cmd)
  rule  checkVarApplsInCmd(CMD)
        {
          CMD -> assign(_, EXP)  |
          CMD -> vardec(_, _, EXP)  |
          CMD -> write(EXP)   |
          CMD -> writeln(EXP)
        }
        checkVarApplsInExp(EXP)
  rule  checkVarApplsInCmd(_)
  // The following rule is for testing only. It will be called
  // if the definition of the predicate is still incomplete
  rule  checkVarApplsInCmd(CMD)
        print "checkVarApplsInCmd has been called with CMD:"
        print CMD

// Check whether all variables applied in an expression have been declared
proc    checkVarApplsInExp(AS_Exp)
  rule  checkVarApplsInExp(varapp(ID))
        {
          Get-SymTab(ID -> m(T, N))
          // "  declared var found: "   $ID " as " pType(T) " [" $N "]\n"
        |
          sourcepos(ID -> POS)
          // "Error in line " $POS ": Undeclared var found: " $ID "\n"
          error "undeclared variable", POS
        }
  rule  checkVarApplsInExp(_)
  // The following rule is for testing only. It will be called
  // if the definition of the predicate is still incomplete
  rule  checkVarApplsInExp(EXP)
        print "checkVarApplsInExp has been called with EXP:"
        print EXP

////////////////////////////////////////////////////////////////////////////////
// Predicates to translate abstract syntax into Java assembler (Jasmin)
// and output the target program to a file:

// The predicates prelude and postlude together output a simple but
// complete Jasmin program. Anything output between the prelude and
// the postlude will be situated in the main method of that program.
proc    outPrelude(NrOfVars:int)
  rule  outPrelude(NrOfVars)
        open "Target.j"
        ";Target produced by compiler alg30"                    pNL
        ";at the Beuth Hochschule, TB5-CPB,WS12/13"             pNL
        ";---------------------------------"                    pNL
        ".class public Target"                                  pNL
        ".super java/lang/Object"                               pNL
        ".method public <init>()V"                              pNL
        pInd "aload_0"                                          pNL
        pInd "invokenonvirtual java/lang/Object/<init>()V"      pNL
        pInd "return"                                           pNL
        ".end method"                                           pNL
        ".method public static main([Ljava/lang/String;)V"      pNL
        ".limit stack  10"                                      pNL
        ".limit locals " $NrOfVars                              pNL
        pInd "ldc \"-------------------------------\""          pNL
        pInd "invokestatic RTS/plnString(Ljava/lang/String;)V"  pNL
                                                                pNL

proc    outPostlude()
  rule  outPostlude()
                                                                pNL
        pInd "ldc \"-------------------------------\""          pNL
        pInd "invokestatic RTS/plnString(Ljava/lang/String;)V"  pNL
        pInd "return"                                           pNL
        ".end method"                                           pNL
        close // The file Target.j

// The next target ID is at the same time the
// number of variables declared in the alg source program:
proc    outAll(AS_Cmd[])
  rule  outAll(SynTree):
        Get-NextTargetID(-> NrOfVars)
        outPrelude(NrOfVars)
        outCmds(SynTree)
        outPostlude()

// Translates CMDS into Jasmin and outputs the result
proc    outCmds(CMDS:AS_Cmd[])
  rule  outCmds(AS_Cmd[])
  rule  outCmds(AS_Cmd[CMD::CMDS]):
        outCmd (CMD)
        outCmds(CMDS)

// Output the translation of a single command
proc    outCmd(AS_Cmd)
  rule  outCmd(read(SI))
        "; read" pNL
        Get-SymTab(SI -> m(TYPE, TI))
        pInd
        {
          TYPE -> bool()      "invokestatic RTS/readBool()I"    pNL
          pInd { Less(TI, 4)  "istore_" $TI | "istore " $TI }
        |
          TYPE -> int()       "invokestatic RTS/readInt()I"     pNL
          pInd { Less(TI, 4)  "istore_" $TI | "istore " $TI }
        |
          TYPE -> string()
          "invokestatic RTS/readString()Ljava/lang/String;"     pNL
          pInd { Less(TI, 4)  "astore_" $TI | "astore " $TI }
        }
        pNL
  rule  outCmd(write(EXP))
        "; write" pNL
        outExp(EXP)
        pInd
        {
          isBool(EXP)   "invokestatic RTS/pBool(I)V"                    |
          isInt(EXP)    "invokestatic RTS/pInt(I)V"                     |
          isString(EXP) "invokestatic RTS/pString(Ljava/lang/String;)V"
        }
        pNL
  rule  outCmd(writeln(EXP))
        "; writeln" pNL
        outExp(EXP)
        pInd
        {
          isBool(EXP)   "invokestatic RTS/plnBool(I)V"                    |
          isInt(EXP)    "invokestatic RTS/plnInt(I)V"                     |
          isString(EXP) "invokestatic RTS/plnString(Ljava/lang/String;)V"
        }
        pNL
  rule  outCmd(vardec(_, _, EXP))
        "; vardec" pNL
        Get-NextTargetID(-> NTI)
        Get-Iterator(-> TI)
        LessOrEqual(TI, NTI)
        {
          { isBool(EXP) | isInt(EXP) }
          outExp(EXP)
          pInd { Less(TI, 4) "istore_" $TI | "istore " $TI }
        |
          isString(EXP)
          pInd "new java/lang/String"                                       pNL
          pInd "dup"                                                        pNL
          outExp(EXP)
          pInd "invokespecial java/lang/String/<init>(Ljava/lang/String;)V" pNL
          pInd { Less(TI, 4) "astore_" $TI | "astore " $TI }
        }
        pNL
        Set-Iterator(TI+1)
  rule  outCmd(assign(SI, EXP))
        "; assign" pNL
        Get-SymTab(SI -> m(TYPE, TI))
        {
          // isBool(EXP)
          TYPE -> bool()
          outExp(EXP)
          pInd { Less(TI, 4) "istore_" $TI | "istore " $TI }
        |
          // isInt(EXP)
          TYPE -> int()
          outExp(EXP)
          pInd { Less(TI, 4) "istore_" $TI | "istore " $TI }
        |
          // isString(EXP)
          TYPE -> string()
          pInd "new java/lang/String"                                       pNL
          pInd "dup"                                                        pNL
          outExp(EXP)
          pInd "invokespecial java/lang/String/<init>(Ljava/lang/String;)V" pNL
          pInd { Less(TI, 4) "astore_" $TI | "astore " $TI }
        }
        pNL
  // The following rule is for testing only. It will be called
  // if the definition of the predicate is still incomplete
  rule  outCmd(CMD)
        print "outCmd has been called with CMD:"
        print CMD

// Output the translation of an expression
// Every expression EXP is translated into Jasmin instructions, which will
// cause the value of EXP to be placed onto the stack of the JVM.
proc    outExp(AS_Exp)
  rule  outExp(lit(VAL))
        {
          VAL -> stringVal(STR) pInd() "ldc \"" $STR "\""
        |
          VAL -> intVal(INT)
          pInd
          {
            Less(INT, 128)   Greater(INT, -129)   "bipush" |
            Less(INT, 32768) Greater(INT, -32769) "sipush" |
                                                  "ldc"
          }
          " " $INT
        |
          VAL -> boolVal(BOOL)  pInd "iconst_" $BOOL
        }
        pNL
  rule  outExp(varapp(SI))
        Get-SymTab(SI -> m(TYPE, TI))
        pInd
        {
          { TYPE -> bool() | TYPE -> int() }
          { Less(TI, 4) "iload_" $TI | "iload " $TI }
        |
          TYPE -> string()  "aload_" $TI
        }
        pNL
  rule  outExp(exp1(OP, EXP))
        {
          OP -> not()
          outExp(EXP)
          pInd "iconst_1" pNL
          pInd "ixor" pNL
        |
          OP -> minus()
          outExp(EXP)
          pInd "ineg" pNL
        }
  rule  outExp(exp2(OP, E1, E2))
        {
          OP -> conc()
          outExp(E1)
          convToString(E1)
          outExp(E2)
          convToString(E2)
          pInd
          "invokestatic RTS/concat(Ljava/lang/String;Ljava/lang/String;)"
          "Ljava/lang/String;"
          pNL
        |
          OP -> lt() compare(E1, E2, "if_icmplt", "lessThan")
        |
          OP -> le() compare(E1, E2, "if_icmple", "lessEquals")
        |
          OP -> eq() compare(E1, E2, "if_icmpeq", "equals")
        |
          OP -> ne() compare(E1, E2, "if_icmpne", "unEquals")
        |
          OP -> ge() compare(E1, E2, "if_icmpge", "greaterEquals")
        |
          OP -> gt() compare(E1, E2, "if_icmpgt", "greaterThan")
        |
          OP -> or()
          outExp(E1)
          outExp(E2)
          pInd "ior" pNL
        |
          OP -> and()
          outExp(E1)
          outExp(E2)
          pInd "iand" pNL
        |
          OP -> add()
          outExp(E1)
          outExp(E2)
          pInd "iadd" pNL
        |
          OP -> sub()
          outExp(E1)
          outExp(E2)
          pInd "isub" pNL
        |
          OP -> mul()
          outExp(E1)
          outExp(E2)
          pInd "imul" pNL
        |
          OP -> div()
          outExp(E1)
          outExp(E2)
          pInd "idiv" pNL
        }
  // The following rule is for testing only. It will be called
  // if the definition of the predicate is still incomplete
  rule  outExp(EXP)
        print "outExp was called with EXP:"
        print EXP

// Prints an indent of a specific size
proc    pInd()
  rule  pInd() : "   "

// Prints an newline escape sequence
proc    pNL()
  rule  pNL() : "\n"

proc    convToString(AS_Exp)
  rule  convToString(EXP)
        {
          isInt(EXP)
          pInd "invokestatic RTS/intToString(I)Ljava/lang/String;"  pNL
        |
          isBool(EXP)
          pInd "invokestatic RTS/boolToString(I)Ljava/lang/String;" pNL
        }?

proc    compare(E1:AS_Exp, E2:AS_Exp, Jasmin:string, JavaID:string)
  rule  compare(E1, E2, J, JID)
        {
          { isBool(E1) | isInt(E1) }
          Get-LabelIterator(-> LI)
          outExp(E1)
          outExp(E2)
          pInd $J " LabelCmp1_" $LI pNL
          outExp(lit(boolVal(0)))
          pInd "goto LabelCmp2_" $LI pNL
          "LabelCmp1_" $LI ":" pNL
          outExp(lit(boolVal(1)))
          "LabelCmp2_" $LI ":" pNL
          Set-LabelIterator(LI+1)
        |
          isString(E1) isString(E2)
          outExp(E1)
          outExp(E2)
          pInd
          "invokestatic RTS/" $JID "(Ljava/lang/String;Ljava/lang/String;)I"
          pNL
        }

// The following condition predicates assume, that the abstract syntax
// is fully type checked and o.k. Only under this assumption do they
// discern expressions of different types.
condition isBool(AS_Exp)
  rule    isBool(lit(boolVal(_)))
  rule    isBool(varapp(SI)) : Get-SymTab(SI -> m(T, _)) T -> bool()
  rule    isBool(exp2(and(), _, _))
  rule    isBool(exp2(eq(), _, _))
  rule    isBool(exp2(ge(), _, _))
  rule    isBool(exp2(gt(), _, _))
  rule    isBool(exp2(le(), _, _))
  rule    isBool(exp2(lt(), _, _))
  rule    isBool(exp2(ne(), _, _))
  rule    isBool(exp1(not(), _))
  rule    isBool(exp2(or(), _, _))

condition isInt(AS_Exp)
  rule    isInt(lit(intVal(_)))
  rule    isInt(varapp(SI)) : Get-SymTab(SI -> m(T, _)) T -> int()
  rule    isInt(exp1(minus(), _))
  rule    isInt(exp2(add(), _, _))
  rule    isInt(exp2(div(), _, _))
  rule    isInt(exp2(mul(), _, _))
  rule    isInt(exp2(sub(), _, _))

condition isString(AS_Exp)
  rule    isString(lit(stringVal(_)))
  rule    isString(varapp(SI)) : Get-SymTab(SI -> m(T, _)) T -> string()
  rule    isString(exp2(conc(), _, _))


////////////////////////////////////////////////////////////////////////////////
// Auxiliary predicates, possibly useful for testing

// Prints the syntax tree CMDS in a format similar to a source program
proc    pCmds(CMDS:AS_Cmd[])
  rule  pCmds(AS_Cmd[])
  rule  pCmds(AS_Cmd[CMD::CMDS])
        pCmd (CMD)
        pCmds(CMDS)

proc    pCmd(AS_Cmd)
  rule  pCmd(CMD)
        {
          CMD -> read(SI)
          "read(" $SI ");"
        |
          CMD -> write(EXP)
          "write("   pExp(EXP) ");"
        |
          CMD -> writeln(EXP)
          "writeln(" pExp(EXP) ");"
        |
          CMD -> vardec(SI, T, EXP)
          pType(T) " " $SI " := " pExp(EXP) ";"
        |
          CMD -> assign(SI, EXP)
          $SI " := " pExp(EXP) ";"
        }
        pNL
  // The following rule is for testing only. It will be called
  // if the definition of the predicate is still incomplete
  rule  pCmd(CMD)
        print "pCMD was called with CMD:"
        print CMD

proc    pType(AS_Type)
  rule  pType(TYPE)
        {
          TYPE -> int()    "int"    |
          TYPE -> bool()   "bool"   |
          TYPE -> string() "string"
        }

proc    pTypeFromExp(AS_Exp)
  rule  pTypeFromExp(EXP)
        {
          isBool(EXP)   pType(bool())   |
          isInt(EXP)    pType(int())    |
          isString(EXP) pType(string())
        }

proc    pExp(AS_Exp)
  rule  pExp(EXP)
        {
          EXP -> lit(VAL)
          pVal(VAL)
        |
          EXP -> varapp(SI)
          $SI
        |
          EXP -> exp1(OP1, EXP2)
          pOp1(OP1)
          {
            EXP2 -> lit(_)
            OP1  -> not()
            " " pExp(EXP2)
          |
            EXP2 -> exp1(_, _)
            "(" pExp(EXP2) ")"
          |
            pExp(EXP2)
          }
        |
          EXP -> exp2(OP2, EXP2, EXP3)
          pExp(EXP2) pOp2(OP2) pExp(EXP3)
        }
  // The following rule is for testing only. It will be called
  // if the definition of the predicate is still incomplete
  rule  pExp(EXP)
        print "pExp was called with EXP:"
        print EXP

proc    pVal(AS_Val)
  rule  pVal(VAL)
        {
          VAL -> intVal   (P1) $P1           |
          VAL -> boolVal  (0)  "false"       |
          VAL -> boolVal  (1)  "true"        |
          VAL -> stringVal(P2) "\"" $P2 "\""
        }

proc    pOp1(AS_Op1)
  rule  pOp1(OP)
        {
          OP -> minus() "-"
        |
          OP -> not()   "not"
        }

proc    pOp2(AS_Op2)
  rule  pOp2(OP)
        " "
        {
          OP -> add()   "+"   |
          OP -> and()   "and" |
          OP -> conc()  "&"   |
          OP -> div()   "/"   |
          OP -> eq()    "="   |
          OP -> ge()    ">="  |
          OP -> gt()    ">"   |
          OP -> le()    "<="  |
          OP -> lt()    "<"   |
          OP -> mul()   "*"   |
          OP -> ne()    "!="  |
          OP -> or()    "or"  |
          OP -> sub()   "-"
        }
        " "