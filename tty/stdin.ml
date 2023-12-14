let stdin_fd = Unix.descr_of_in_channel stdin
let decoder = Uutf.decoder ~encoding:`UTF_8 `Manual

let set_raw_mode () =
  let termios = Unix.tcgetattr stdin_fd in
  let new_termios =
    Unix.
      { termios with c_icanon = false; c_echo = false; c_vmin = 1; c_vtime = 0 }
  in
  Unix.tcsetattr stdin_fd TCSANOW new_termios;
  termios

let restore_mode termios = Unix.tcsetattr stdin_fd TCSANOW termios

let try_read () =
  let bytes = Bytes.create 8 in
  match Unix.read stdin_fd bytes 0 8 with
  | exception Unix.(Unix_error ((EINTR | EAGAIN | EWOULDBLOCK), _, _)) -> ()
  | len -> Uutf.Manual.src decoder bytes 0 len

let uchar_to_str u =
  let buf = Buffer.create 8 in
  Uutf.Buffer.add_utf_8 buf u;
  Buffer.contents buf

let read_utf8 () =
  match Uutf.decode decoder with
  | `Uchar u -> `Read (uchar_to_str u)
  | `End -> `End
  | `Await ->
      try_read ();
      `Retry
  | `Malformed err -> `Malformed err

let setup () =
  Unix.set_nonblock stdin_fd;
  set_raw_mode ()

let shutdown termios = restore_mode termios
