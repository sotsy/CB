// alg source program TST1.ALG for compiler alg31
// Should contain a "representative" for each command in alg31

int  i1 := 4;
int  i2 := 2;

bool b1 := false;
bool b2 := true;

// Arithmetic operators:
writeln("---------------+------------------+");
writeln("     expected  | found            |");
writeln("---------------+------------------+");
write  ("99-001      6  | "); writeln(4+2);
write  ("99-002      2  | "); writeln(4-2);
write  ("99-003      8  | "); writeln(4*2);
write  ("99-004      2  | "); writeln(4/2);
writeln("---------------+-------------------");
write  ("99-005      6  | "); writeln(i1+i2);
write  ("99-006      2  | "); writeln(i1-i2);
write  ("99-007      8  | "); writeln(i1*i2);
write  ("99-008      2  | "); writeln(i1/i2);
writeln("---------------+-------------------");
write  ("99-009      10 | "); writeln(i1+ 3*i2);
write  ("99-010      14 | "); writeln(i1* 3+i2);
write  ("99-011      4  | "); writeln( 8/ 3*i2);
write  ("99-012      2  | "); writeln( 8-i1-i2);
writeln("---------------+-------------------");
write  ("99-013      14 | "); writeln((i1+ 3)*i2);
write  ("99-014      20 | "); writeln(i1* (3+i2));
write  ("99-015      1  | "); writeln( 8/ (3*i2));
write  ("99-016      6  | "); writeln( 8-(i1-i2));
writeln("---------------+-------------------");
write  ("99-017      -5 | "); writeln(-3 + -2);
write  ("99-018      -1 | "); writeln(-3 - -2);
write  ("99-019      6  | "); writeln(-3 * -2);
write  ("99-020      1  | "); writeln(-3 / -2);
writeln("---------------+-------------------");
write  ("99-021      -3 | "); writeln(      -3   );
write  ("99-022      3  | "); writeln(    -(-3  ));
write  ("99-023      -3 | "); writeln(  -(-(-3 )));
write  ("99-024      3  | "); writeln(-(-(-(-3))));

// Boolean operators:
writeln("---------------+------------------+");
writeln("     expected  | found            |");
writeln("---------------+------------------+");
write  ("99-025   false | "); writeln(false or  false);
write  ("99-026   true  | "); writeln(false or  true );
write  ("99-027   true  | "); writeln(true  or  false);
write  ("99-028   true  | "); writeln(true  or  true );
writeln("---------------+-------------------");
write  ("99-029   false | "); writeln(false and false);
write  ("99-030   false | "); writeln(false and true );
write  ("99-031   false | "); writeln(true  and false);
write  ("99-032   true  | "); writeln(true  and true );
writeln("---------------+-------------------");
write  ("99-033   true  | "); writeln(not false);
write  ("99-034   false | "); writeln(not true );
write  ("99-035   false | "); writeln(not(not false));
write  ("99-036   true  | "); writeln(not(not true ));
writeln("---------------+-------------------");
write  ("99-037   false | "); writeln(b1 or  b1);
write  ("99-038   true  | "); writeln(b1 or  b2);
write  ("99-039   true  | "); writeln(b2 or  b1);
write  ("99-040   true  | "); writeln(b2 or  b2);
writeln("---------------+-------------------");
write  ("99-041   false | "); writeln(b1 and b1);
write  ("99-042   false | "); writeln(b1 and b2);
write  ("99-043   false | "); writeln(b2 and b1);
write  ("99-044   true  | "); writeln(b2 and b2);
writeln("---------------+-------------------");
write  ("99-045   true  | "); writeln(    not b1 );
write  ("99-046   false | "); writeln(    not b2 );
write  ("99-047   false | "); writeln(not(not b1));
write  ("99-048   true  | "); writeln(not(not b2));

// Comparison operators yielding true:
writeln("---------------+------------------+");
writeln("     expected  | found            |");
writeln("---------------+------------------+");
write  ("99-049    true | "); writeln(1< 2);
write  ("99-050    true | "); writeln(1<=1);
write  ("99-051    true | "); writeln(1<=2);
write  ("99-052    true | "); writeln(1 =1);
write  ("99-053    true | "); writeln(1!=2);
write  ("99-054    true | "); writeln(2>=2);
write  ("99-055    true | "); writeln(2>=1);
write  ("99-056    true | "); writeln(2> 1);
writeln("---------------+-------------------");
write  ("99-057    true | "); writeln(false< true );
write  ("99-058    true | "); writeln(false<=false);
write  ("99-059    true | "); writeln(false<=true );
write  ("99-060    true | "); writeln(false =false);
write  ("99-061    true | "); writeln(false!=true );
write  ("99-062    true | "); writeln(true >=true );
write  ("99-063    true | "); writeln(true >=false);
write  ("99-064    true | "); writeln(true > false);
writeln("---------------+-------------------");
write  ("99-065    true | "); writeln("ABC"< "ACB");
write  ("99-066    true | "); writeln("ABC"<="ABC");
write  ("99-067    true | "); writeln("ABC"<="ACB");
write  ("99-068    true | "); writeln("ABC" ="ABC");
write  ("99-069    true | "); writeln("ABC"!="ACB");
write  ("99-070    true | "); writeln("ACB">="ACB");
write  ("99-071    true | "); writeln("ACB">="ABC");
write  ("99-072    true | "); writeln("ACB"> "ABC");

// Comparison operators yielding false:
writeln("---------------+------------------+");
writeln("     expected  | found            |");
writeln("---------------+------------------+");
write  ("99-073   false | "); writeln(2< 1);
write  ("99-074   false | "); writeln(2< 2);
write  ("99-075   false | "); writeln(2<=1);
write  ("99-076   false | "); writeln(2 =1);
write  ("99-077   false | "); writeln(2!=2);
write  ("99-078   false | "); writeln(1>=2);
write  ("99-079   false | "); writeln(1> 2);
write  ("99-080   false | "); writeln(1> 1);
writeln("---------------+-------------------");
write  ("99-081   false | "); writeln(true < false);
write  ("99-082   false | "); writeln(true < true );
write  ("99-083   false | "); writeln(true <=false);
write  ("99-084   false | "); writeln(true  =false);
write  ("99-085   false | "); writeln(true !=true );
write  ("99-086   false | "); writeln(false>=true );
write  ("99-087   false | "); writeln(false> true );
write  ("99-088   false | "); writeln(false> false);
writeln("---------------+-------------------");
write  ("99-089   false | "); writeln("ACB"< "ABC");
write  ("99-090   false | "); writeln("ACB"< "ACB");
write  ("99-091   false | "); writeln("ACB"<="ABC");
write  ("99-092   false | "); writeln("ACB" ="ABC");
write  ("99-093   false | "); writeln("ACB"!="ACB");
write  ("99-094   false | "); writeln("ABC">="ACB");
write  ("99-095   false | "); writeln("ABC"> "ACB");
write  ("99-096   false | "); writeln("ABC"> "ABC");

// Concatenation operator:
writeln("---------------+------------------+");
writeln("     expected  | found            |");
writeln("---------------+------------------+");
write  ("99-097     ABC | "); writeln("AB"  & "C");
write  ("99-098     ABC | "); writeln("A"   & "B"   & "C"  );
write  ("99-099     AB3 | "); writeln("A"   & "B"   &  3   );
write  ("99-100     A2C | "); writeln("A"   &  2    & "C"  );
write  ("99-101     1BC | "); writeln( 1    & "B"   & "C"  );
write  ("99-102 ABfalse | "); writeln("A"   & "B"   & false);
write  ("99-103 AfalseC | "); writeln("A"   & false & "C"  );
write  ("99-104 falseBC | "); writeln(false & "B"   & "C"  );
write  ("99-105 12false | "); writeln( 1    &  2    & false);
write  ("99-106 1false3 | "); writeln( 1    & false &  3   );
write  ("99-107 false23 | "); writeln(false &  2    &  3   );

// Mixed operators:
writeln("---------------+------------------+");
writeln("     expected  | found            |");
writeln("---------------+------------------+");
write  ("99-108    AB5  | "); writeln("AB"    &  2 + 3   );
write  ("99-109    5AB  | "); writeln( 2 + 3  & "AB"     );
write  ("99-110   true  | "); writeln( 4 +  2 <  4 *  2  );
write  ("99-111   false | "); writeln(i1 + i2 > i1 * i2  );
write  ("99-112   falseA| "); writeln( not true  & "A"   );
write  ("99-113   Atrue | "); writeln( "A"       & not b1);
write  ("99-114   -3A   | "); writeln( -3        & "A"   );
write  ("99-115   A-3   | "); writeln( "A"       & -3    );
write  ("99-116   true  | "); writeln( true or  (3 < 1)  );
write  ("99-117   false | "); writeln((true or   3)< 1   ); // type error
writeln("---------------+-------------------");
