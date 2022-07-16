build:
	openscad -o crossbow_2.85mm_ply.dxf -D body_ply_thickness=2.85 -D full_render=true crossbow.scad
	openscad -o crossbow_3mm_ply.dxf -D body_ply_thickness=3 -D full_render=true crossbow.scad