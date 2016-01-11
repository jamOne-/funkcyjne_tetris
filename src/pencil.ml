open Types

let draw (game_state: gameState) (pencil_data: pencilData) =
    let board_offset = { x = 50; y = 35; } in
    let preview_offset = { x = 515; y = 80; } in
    let position_of_board = Sdlvideo.rect (board_offset.x - 1) (board_offset.y - 1) 302 542 in
    let position_of_preview = Sdlvideo.rect (preview_offset.x - 1) (preview_offset.y - 1) 122 122 in
    let brick = game_state.brick in
    let calc_rect x y offset =
        Sdlvideo.rect (x * 30 + offset.x) (y * 30 + offset.y) 30 30 in
    
    
    Sdlvideo.fill_rect pencil_data.screen (Sdlvideo.map_RGB pencil_data.screen (22, 25, 29));
    
    (* BOARD DRAWING *)
    Sdlvideo.blit_surface ~dst_rect:position_of_board ~src:pencil_data.board ~dst:pencil_data.screen ();
    Utils.iterate game_state.board (fun y x field ->
        match field with
        | Empty         ->  ()
        | Square color  ->  Sdlvideo.blit_surface ~dst_rect:(calc_rect x y board_offset) ~src:pencil_data.squares.(color) ~dst:pencil_data.screen ());
    
    (* BRICK DRAWING *)
    Utils.iterate brick.box (fun y x field ->
        match field with
        | Empty         ->  ()
        | Square color  ->  Sdlvideo.blit_surface ~dst_rect:(calc_rect (x + brick.position.x) (y + brick.position.y) board_offset) ~src:pencil_data.squares.(color) ~dst:pencil_data.screen ());
        
    (* PREVIEW DRAWING *)
    Sdlvideo.blit_surface ~dst_rect:position_of_preview ~src:pencil_data.preview ~dst:pencil_data.screen ();
    Utils.iterate game_state.next_brick.box (fun y x field ->
        match field with
        | Empty         ->  ()
        | Square color  ->  Sdlvideo.blit_surface ~dst_rect:(calc_rect x y preview_offset) ~src:pencil_data.squares.(color) ~dst:pencil_data.screen ());
    
    
    let next_brick = Sdlttf.render_text_blended pencil_data.font_40 "Next brick" ~fg:Sdlvideo.white in
    let points_s = Sdlttf.render_text_blended pencil_data.font_40 "Points:" ~fg:Sdlvideo.white in
    let points_n = Sdlttf.render_text_blended pencil_data.font_40 (string_of_int game_state.points) ~fg:Sdlvideo.white in    
    Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 465; y = 35 }) ~src:next_brick ~dst:pencil_data.screen ();
    Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 505; y = 250 }) ~src:points_s ~dst:pencil_data.screen ();
    Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 350 + 225 - (Sdlvideo.surface_info points_n).w / 2; y = 290 }) ~src:points_n ~dst:pencil_data.screen ();
    
    if game_state.state = End
    then (
        let llamapoints_1 = Sdlttf.render_text_blended pencil_data.font_40 "Llamacorn won!" ~fg:Sdlvideo.yellow in
        let llamapoints_2 = Sdlttf.render_text_blended pencil_data.font_30 "I am so sorry," ~fg:Sdlvideo.green in
        let llamapoints_3 = Sdlttf.render_text_blended pencil_data.font_30 "it had only" ~fg:Sdlvideo.black in
        let llamapoints_4 = Sdlttf.render_text_blended pencil_data.font_40 (string_of_int (game_state.points + 1) ^ " points") ~fg:Sdlvideo.red in

        Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 0; y = 0 }) ~src:pencil_data.black_surf ~dst:pencil_data.screen ();
        Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 200; y = 200 }) ~src:pencil_data.llamacorn ~dst:pencil_data.screen ();
        Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 220; y = 150 }) ~src:llamapoints_1 ~dst:pencil_data.screen ();
        Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 50; y = 200 }) ~src:llamapoints_2 ~dst:pencil_data.screen ();
        Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 100; y = 250 }) ~src:llamapoints_3 ~dst:pencil_data.screen ();
        Sdlvideo.blit_surface ~dst_rect:(calc_rect 0 0 { x = 25; y = 330 }) ~src:llamapoints_4 ~dst:pencil_data.screen ()
    );
    Sdlvideo.flip pencil_data.screen