
// This is a design for a laser-cut plywood crossbow.


// Z-fight fudge. Tweak dimensions this much to avoid z-fighting in the rendering.
zff = 0.01;
// How many facets on the circles.
$fn = 32;
// Length of body
body_length = 300;
// Height of body
body_height = 40;
// The thickness of each layer of the body's plywood
body_ply_thickness = 3;
// How many layers of plywood laminated into the body
body_layers = 5;

// The radius of the cord.
cord_r = 1;
// The radius of the sear wheel.
sear_r = 10;
// The depth of the cutout into the sear that engages with the trigger arm.
sear_trigger_notch = 2;
// The angle the trigger arm makes to the sear.
sear_trigger_angle = 25;
// The radius of the shaft through the sear.
sear_shaft_r = 1.5;

// This is the rotating mechanism that engages with the cord and the trigger arm to retain
// the cord tension until the trigger is squeezed.
module sear() {
    difference() {
        // The main body of the sear.
        cylinder(r=sear_r, h=body_ply_thickness);
        // The cutout that engages with the cord.
        translate([-100, sear_r-cord_r*2,-zff]) cube([100,cord_r*2, body_ply_thickness+2*zff]);
        // The cutout that engages with the trigger arm.
        rotate([0,0,sear_trigger_angle])
            translate([-100, -sear_r-sear_trigger_notch/2,-zff])
                cube([100,sear_trigger_notch*2, body_ply_thickness+2*zff]);
        // The hole through the centre of the sear through which the shaft passes to secure the sear inside the body.
        cylinder(r=sear_shaft_r, h=body_ply_thickness);
    }
}

// This is the body of the crossbow. It contains the trigger arm and the sear.
module body() {
    // Build up the body of the crossbow out of layers.
    for (i = [0:body_layers]) {
        translate([0,0,i*body_ply_thickness]) cube([body_length, body_height, body_ply_thickness]);
    }
}

// body();
sear();