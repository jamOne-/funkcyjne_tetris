open Types

let draw (game_state: gameState) (pencil_data: pencilData) =
    let board_offset = { x = 50; y = 35; } in
    let preview_offset = { x = 515; y = 80; } in
    let position_of_board = Sdlvideo.rect (board_offset.x - 1) (board_offset.y - 1) 302 542 in
    let position_of_preview = Sdlvideo.rect (preview_offset.x - 1) (preview_offset.y - 1) 122 122 in
    let get_rect surf x y =
        let info = Sdlvideo.surface_info surf in
        Sdlvideo.rect x y info.w info.h in
    let calc_rect x y offset =
        Sdlvideo.rect (x * 30 + offset.x) (y * 30 + offset.y) 30 30 in
    let center_rect surf x_begin x_end y =
        get_rect surf ((x_end - x_begin - (Sdlvideo.surface_info surf).w) / 2 + x_begin) y in
    
    
    Sdlvideo.fill_rect pencil_data.screen (Sdlvideo.map_RGB pencil_data.screen (22, 25, 29));
    
    (* BOARD DRAWING *)
    Sdlvideo.blit_surface ~dst_rect:position_of_board ~src:pencil_data.board ~dst:pencil_data.screen ();
    Utils.iterate game_state.board (fun y x field ->
        match field with
        | Empty         ->  ()
        | Square color  ->  Sdlvideo.blit_surface ~dst_rect:(calc_rect x y board_offset) ~src:pencil_data.squares.(color) ~dst:pencil_data.screen ());
    
    (* BRICK DRAWING *)
    Utils.iterate game_state.brick.box (fun y x field ->
        match field with
        | Empty         ->  ()
        | Square color  ->  Sdlvideo.blit_surface ~dst_rect:(calc_rect (x + game_state.brick.position.x) (y + game_state.brick.position.y) board_offset) ~src:pencil_data.squares.(color) ~dst:pencil_data.screen ());
        
    (* PREVIEW DRAWING *)
    Sdlvideo.blit_surface ~dst_rect:position_of_preview ~src:pencil_data.preview ~dst:pencil_data.screen ();
    Utils.iterate game_state.next_brick.box (fun y x field ->
        match field with
        | Empty         ->  ()
        | Square color  ->  Sdlvideo.blit_surface ~dst_rect:(calc_rect x y preview_offset) ~src:pencil_data.squares.(color) ~dst:pencil_data.screen ());
    
    
    let next_brick = Sdlttf.render_text_blended pencil_data.font_40 "Next brick" ~fg:Sdlvideo.white in
    let points_s = Sdlttf.render_text_blended pencil_data.font_40 "Points:" ~fg:Sdlvideo.white in
    let points_n = Sdlttf.render_text_blended pencil_data.font_40 (string_of_int game_state.points) ~fg:Sdlvideo.white in
    let highscore_s = Sdlttf.render_text_blended pencil_data.font_40 "Highscore:" ~fg:Sdlvideo.yellow in
    let highscore_n = Sdlttf.render_text_blended pencil_data.font_40 (string_of_int game_state.highscore) ~fg:Sdlvideo.yellow in   
    Sdlvideo.blit_surface ~dst_rect:(center_rect next_brick 350 800 35) ~src:next_brick ~dst:pencil_data.screen ();
    Sdlvideo.blit_surface ~dst_rect:(center_rect points_s 350 800 250) ~src:points_s ~dst:pencil_data.screen ();
    Sdlvideo.blit_surface ~dst_rect:(center_rect points_n 350 800 290) ~src:points_n ~dst:pencil_data.screen ();
    Sdlvideo.blit_surface ~dst_rect:(center_rect highscore_s 350 800 360) ~src:highscore_s ~dst:pencil_data.screen ();
    Sdlvideo.blit_surface ~dst_rect:(center_rect highscore_n 350 800 400) ~src:highscore_n ~dst:pencil_data.screen ();
    
    if game_state.state = End
    then (
        let press_r = Sdlttf.render_text_blended pencil_data.font_40 "Press R key to restart game" ~fg:Sdlvideo.white in
        Sdlvideo.blit_surface ~dst_rect:(center_rect pencil_data.black_surf 0 800 0) ~src:pencil_data.black_surf ~dst:pencil_data.screen ();
        Sdlvideo.blit_surface ~dst_rect:(center_rect press_r 0 800 30) ~src:press_r ~dst:pencil_data.screen ();
        
        if      game_state.points > game_state.highscore
        then    (
            let wow_1 = Sdlttf.render_text_blended pencil_data.font_30 "Wow!" ~fg:Sdlvideo.white in
            let wow_2 = Sdlttf.render_text_blended pencil_data.font_40 (string_of_int game_state.points) ~fg:Sdlvideo.yellow in
            let wow_3 = Sdlttf.render_text_blended pencil_data.font_30 "is the new highscore!" ~fg:Sdlvideo.white in
            
            Sdlvideo.blit_surface ~dst_rect:(get_rect wow_1 200 200) ~src:wow_1 ~dst:pencil_data.screen ();
            Sdlvideo.blit_surface ~dst_rect:(get_rect wow_1 260 230) ~src:wow_2 ~dst:pencil_data.screen ();
            Sdlvideo.blit_surface ~dst_rect:(get_rect wow_1 280 270) ~src:wow_3 ~dst:pencil_data.screen ();
            Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 400; y = 300 }) ~src:pencil_data.lyingllama ~dst:pencil_data.screen ()
        )
        else    (
            let llamapoints_1 = Sdlttf.render_text_blended pencil_data.font_40 "Llamacorn won!" ~fg:Sdlvideo.yellow in
            let llamapoints_2 = Sdlttf.render_text_blended pencil_data.font_30 "I am so sorry," ~fg:Sdlvideo.green in
            let llamapoints_3 = Sdlttf.render_text_blended pencil_data.font_30 "it had only" ~fg:Sdlvideo.red in
            let llamapoints_4 = Sdlttf.render_text_blended pencil_data.font_40 (string_of_int (game_state.highscore) ^ " points") ~fg:Sdlvideo.magenta in

            Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 200; y = 200 }) ~src:pencil_data.llamacorn ~dst:pencil_data.screen ();
            Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 220; y = 150 }) ~src:llamapoints_1 ~dst:pencil_data.screen ();
            Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 50; y = 200 }) ~src:llamapoints_2 ~dst:pencil_data.screen ();
            Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 100; y = 250 }) ~src:llamapoints_3 ~dst:pencil_data.screen ();
            Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 25; y = 330 }) ~src:llamapoints_4 ~dst:pencil_data.screen ()
        )
    );
    Sdlvideo.flip pencil_data.screen