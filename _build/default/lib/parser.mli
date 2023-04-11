
(* The type of tokens. *)

type token = 
  | VAR of (string)
  | TIMES
  | RPAREN
  | POW
  | PLUS
  | MINUS
  | LPAREN
  | INT of (int)
  | EQUALS
  | EOF
  | DIV
  | DDX of (string)
  | COMMA

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val rule: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (string Ast.rule)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (string Ast.expr)
