
// This is a design for a laser-cut plywood crossbow.


// Z-fight fudge. Tweak dimensions this much to avoid z-fighting in the rendering.
// This does not consequentially affect the dimensions physical product.
zff = 0.01;
// How many facets on the circles.
$fn = 32;
// Length of body
body_length = 300;
// Height of body
body_height = 30;
// The thickness of each layer of the body's plywood
body_ply_thickness = 3;
// How many layers of plywood laminated into the body
body_layers = 5;
// The overall thickness of the body.
body_thickness = body_ply_thickness * body_layers;

// Radius of the bolt fired from this crossbow
bolt_r = 2;
// This is the depth of the groove in the top of the body that guides the bolt when fired.
bolt_groove_depth = bolt_r;
// This is the length of the bolt.
bolt_length = 150;

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
        // TODO add hole to engage with return spring.
    }
}

// This is the body of the crossbow. It contains the trigger arm and the sear.
module body() {
    difference () {
        // Build up the body of the crossbow out of layers.
        for (i = [0:body_layers-1]) {
            translate([0,0,i*body_ply_thickness]) cube([body_length, body_height, body_ply_thickness]);
        }
        // This is the groove that guides the bolt when fired.
        translate([body_length - bolt_length+zff, body_height-bolt_groove_depth+zff, floor(body_layers/2)*body_ply_thickness])
            cube([bolt_length, bolt_groove_depth, body_ply_thickness]);
        // TODO add shafts for sear and trigger.
        // TODO add holes to engage with the springs for the sear and trigger.
        // TODO add the bolt retention/cord guide arm.
    }
}

// This arm protrudes below the body and engages with the sear.
module trigger() {
    // TODO
}

// The number of layers of plywood forming the bow.
bow_layers = 3;
// The thickness of each layer of plywood forming the bow.
bow_ply_thickness = 3;
// The left-to-right length of the bow when assembled.
bow_length = 300;
// The height of the bow.
bow_height = 20;
// The reduction in length of each layer of the bow as a proportion of the length,
// per layer. Think of a leaf spring.
bow_leaf_ratio = 0.3;
// This is the distance between the end of the bow and the cord hole.
bow_cord_tie_offset = 10;

// This is the bow attached to the front of the crossbow. It is bent with the tension of the cord.
module bow() {
    difference () {
        // This is the main body of the bow. It is made of stacked layers of decreasing length.
        for (i = [0:bow_layers-1]) {
            translate([(bow_leaf_ratio*i*bow_length)/2,0,i*bow_ply_thickness])
                cube([bow_length - bow_leaf_ratio*i*bow_length, bow_height, bow_ply_thickness]);
        }
        // This is the notch cut in the top of the bow to let the bolt through.
        translate([bow_length/2-bolt_r, bow_height-bolt_r*2+zff,-zff]) cube([bolt_r*2, bolt_r*2,100]);
        // These are the holes near the end of the bow to tie off the cord.
        translate([bow_cord_tie_offset,bow_height/2,-zff]) cylinder(r=cord_r*2, h=100);
        translate([bow_length - bow_cord_tie_offset,bow_height/2,-zff]) cylinder(r=cord_r*2, h=100);
        // TODO Work out the best way to align the spring force of the bow with the axis of action
        // of the bolt. Currently lots of force will go into dragging the cord along the top of the body.
        // Perhaps make the bolt hole in the centre of the bow, and move the bow up considerbly. May need
        // gussets to transmit force to the body.
        // TODO round over the ends of the bow.
    }
}

// This shows all the parts of the crossbow assembled for visual fit checking.
module assembled() {
    body();
    translate([body_length - bolt_length, body_height - sear_r + cord_r*2, floor(body_layers/2)*body_ply_thickness]) sear();
    translate([body_length,body_height-bow_height,body_thickness/2]) rotate([0,-90,0]) translate([-bow_length/2,0,0]) bow();
}
// body();
// bow();

assembled();