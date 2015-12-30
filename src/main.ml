let rec loop game =
    match Sdlevent.wait_event () with
    | KEYDOWN { keysym = KEY_ESCAPE } ->
        print_endline "You pressed escape! The fun is over now."
    | event ->
        Controller.handle game event;
        loop game
    
let init () =
    let game = ({
        game_state  = Gamestate.new_game ();
        timer_info  = {
            running = true;
            speed   = 1.0
        };
        pencil_info = {
            screen  = Sdlvideo.set_video_mode 800 600 [`DOUBLEBUF];
            squares = Array.init 4 (fun i -> Sdlloader.load_image ("assets/square_" ^ (string_of_int i) ^ ".png"));
            board   = Sdlloader.load_image "assets/board.png";
            (*font    = Sdlttf.open_font font_filename 24*)
        }
    }: Controller.gameInfo) in
    let timer_cb () = Sdlevent.add [USER 0] in
    let timer_thread = Gametimer.create_game_timer timer_cb game.timer_info in
        
    Pencil.draw game.game_state game.pencil_info;
    loop game;
    game.timer_info.running <- false;
    Thread.join timer_thread    

let main () =
    Sdl.init [`VIDEO; `AUDIO];
    at_exit Sdl.quit;
    Sdlttf.init ();
    at_exit Sdlttf.quit;
    Sdlmixer.open_audio ();
    at_exit Sdlmixer.close_audio;
    init ()

let _ = main ()