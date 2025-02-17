open Ast
open Modules

let showOp = function 
  | Subt -> "-"
  | Add -> "+"
  | Mult -> "*"
  | Div -> "/"
  | Pow -> "^"
let rec showExpr = function
  | Fun (f, lst) -> f^"("^String.concat "," (List.map showExpr lst) ^")"
  | Int i -> string_of_int i
  | Var i -> i
  | Binop (op,l,r) -> showExprParens l ^ showOp op ^ showExprParens r
  | Ddx (v,e) -> "d/d"^v^" "^showExprParens e
and showExprParens e = match e with 
  | Binop _ -> "("^showExpr e ^")"
  | Ddx _ -> "("^showExpr e ^")"
  | _ -> showExpr e

(** [parseExpr s] parses [s] into an AST. *)
let parseExpr (s : string) : string expr =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast

(** [parseRule s] parses [s] into a rule. *)
let parseRule (s : string) : string rule =
    let lexbuf = Lexing.from_string s in
    let ast = Parser.rule Lexer.read lexbuf in
    ast



module ApplyRule = ApplyRule (Substitution)

let rec apply_rules expr =
  function [] -> None
         | ((x,desc)::xs) -> (match ApplyRule.apply_rule x expr with
                                  | None -> apply_rules expr xs
                                  | Some v -> Some (v,desc))

(** apply_to_nf [rules] [expr]
    applies the rules in [rules] to [expr] until no more rules can be applied *)
let rec apply_to_nf rules expr
  = match (apply_rules expr (List.combine rules rules)) with
     | None -> []
     | (Some (e,d)) -> (e,d) :: apply_to_nf rules e

let showRule (Rule (e1,e2)) = showExpr e1 ^ " = " ^ showExpr e2
