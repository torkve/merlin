(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

open Std

(* The lexical analyzer *)

val init : unit -> unit
val token: Lexing.lexbuf -> Chunk_parser.token
val skip_sharp_bang: Lexing.lexbuf -> unit

type error =
  | Illegal_character of char
  | Illegal_escape of string
  | Unterminated_comment of Location.t
  | Unterminated_string
  | Unterminated_string_in_comment of Location.t
  | Keyword_as_label of string
  | Literal_overflow of string
;;

exception Error of error * Location.t

open Format

val set_extension : enabled:bool -> (string * Chunk_parser.token) list -> unit
val report_error: formatter -> error -> unit

val in_comment : unit -> bool;;
val in_string : unit -> bool;;


val print_warnings : bool ref

(* Comments are filtered out from the token rule and stored in a global
   variable. *)
type comment = string * Location.t

(* If the variable is not None, each new comment will be prepended to the
 * variable *)
val comments : comment list ref option fluid

(* If you want to get the raw output, including comments, from the lexer, use
   the [token_with_comments] entry point. *)
val token_with_comments : Lexing.lexbuf -> Chunk_parser.token
