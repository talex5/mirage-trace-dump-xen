(* Copyright (C) 2014, Thomas Leonard *)

open Bigarray

type t
type domid

type log_buffer = (char, int8_unsigned_elt, c_layout) Array1.t

val domid_of_string : string -> [`Ok of domid | `Error of string]

val pp_domid : Format.formatter -> domid -> unit

val connect : domid -> [ `Ok of t | `Error of string ]
(** [connect domID] looks up [domID]'s trace buffer details from XenStore. *)

val size : t -> int
(** Size of guest's trace buffer in bytes. *)

val load : t -> log_buffer -> unit
(** [load t dst] copies [t]'s trace buffer to [dst] *)
