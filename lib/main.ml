(* Copyright (C) 2014, Thomas Leonard *)

let save_as domid path =
  let open Bigarray in
  match Xen_trace_source.connect domid with
  | `Error m -> `Error (false, m)
  | `Ok source ->
    let ba = Array1.create char c_layout (Xen_trace_source.size source) in
    Xen_trace_source.load source ba;
    begin match path with
      | "-" ->
        for i = 0 to Array1.dim ba - 1 do
          output_char stdout (Array1.get ba i)
        done
      | path ->
        let fd = Unix.(openfile path [O_RDWR; O_CREAT; O_TRUNC; O_CLOEXEC] 0o644) in
        let size = Array1.dim ba in
        Unix.ftruncate fd size;
        let dst =
          Unix.map_file fd char c_layout true [| size |]
          |> Bigarray.array1_of_genarray
        in
        Array1.blit ba dst;
        Unix.close fd
    end;
    `Ok ()

open Cmdliner

let xen_domain_id : (_ Arg.converter) = Xen_trace_source.(domid_of_string, pp_domid)

let trace_dom =
  let doc = "The Xen domain name or ID from which to load the trace data." in
  Arg.(required @@ pos 0 (some xen_domain_id) None @@ info ~doc ~docv:"DOMID" [])

let output_path =
  let doc = "Path of trace file to write." in
  Arg.(required @@ pos 1 (some string) None @@ info ~doc ~docv:"FILE" [])

let () =
  let doc = "extract mirage-profile trace data from a Xen domain" in
  let man = [
    `S "DESCRIPTION";
    `P "$(tname) saves trace data from a Xen domain.";
    `P "To display a trace from a remote Xen guest:";
    `P "ssh xen-dom0 mirage-trace-dump-xen -d my-xen-guest - | mirage-trace-viewer-gtk -";
  ] in
  let info = Term.info ~doc ~man "mirage-trace-dump-xen" in
  let term = Term.(ret (pure save_as $ trace_dom $ output_path)) in
  match Term.eval (term, info) with
  | `Ok () -> ()
  | `Version | `Help -> ()
  | `Error _ -> exit 1
