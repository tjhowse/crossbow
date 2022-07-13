
// This is a design for a laser-cut plywood crossbow.


// Z-fight fudge. Tweak dimensions this much to avoid z-fighting in the rendering.
// This does not consequentially affect the dimensions physical product.
zff = 0.01;
// How many facets on the circles.
$fn = 32;
// Length of body
body_length = 200;
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
bolt_length = 100;

// The radius of the cord.
cord_r = 1;
// The radius of the sear wheel.
sear_r = 10;
// The depth of the cutout into the sear that engages with the trigger arm.
sear_trigger_notch = 3;
// The angle the trigger arm makes to the sear.
sear_trigger_angle = 25;
// The radius of the shaft through the sear.
sear_shaft_r = 1.5;
// This is the clearance between the sear and the body
sear_body_clearance = 0.5;

// The number of layers of plywood forming the bow.
bow_layers = 3;
// The thickness of each layer of plywood forming the bow.
bow_ply_thickness = 3;
// The left-to-right length of the bow when assembled.
bow_length = 200;
// The height of the bow.
bow_height = 15;
// The reduction in length of each layer of the bow as a proportion of the length,
// per layer. Think of a leaf spring.
bow_leaf_ratio = 0.3;
// This is the distance between the end of the bow and the cord hole.
bow_cord_tie_offset = 10;
// This is the overall thickness of the bow at its thickest point.
bow_thickness = bow_ply_thickness * bow_layers;


// This is the offset between the sear and body origins
sear_body_offset = [body_length - bolt_length, body_height - sear_r + cord_r*2, floor(body_layers/2)*body_ply_thickness];
// This is the offset between the bow and body origins
bow_body_offset = [body_length,body_height-bow_height,body_thickness/2];

// This is the overall length of the trigger.
trigger_length = 80;
// This is the height of the trigger.
trigger_height = 8;
// This is the thickness of the ply used for the trigger.
trigger_ply_thickness = body_ply_thickness;
// This is the offset between the trigger and sear module origins.
trigger_sear_offset = [trigger_length,trigger_height+sear_r-sear_trigger_notch,0];
// This is the distance from the sear end of the trigger for the trigger rotation shaft.
trigger_shaft_distance_from_sear_end = 15;
// This is the offset between the origin of the trigger module and its shaft.
trigger_shaft_offset = [trigger_length-trigger_shaft_distance_from_sear_end, trigger_height/2,0];
// This is the radius of the shaft for the trigger.
trigger_shaft_r = sear_shaft_r;

// This is the gap left between parts laid out for laser cutting.
laser_clearance = 0.5;

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
            translate([-100, -sear_r,-zff])
                cube([100,sear_trigger_notch, body_ply_thickness+2*zff]);
        // The hole through the centre of the sear through which the shaft passes to secure the sear inside the body.
        cylinder(r=sear_shaft_r, h=body_ply_thickness);
        // TODO add hole to engage with return spring.
    }
}
mechanism_cutout_x = 60;
mechanism_cutout_y = body_height;
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
        translate(sear_body_offset) union () {
            // This is the shaft for the sear.
            translate([0,0,-50]) cylinder(r=sear_shaft_r, h=100);
            // This is the shaft for the trigger.
            rotate([0,0,sear_trigger_angle])
                translate(-trigger_sear_offset)
                    translate(trigger_shaft_offset)
                        translate([0,0,-50]) cylinder(r=trigger_shaft_r, h=100);
        }
        // This is the cutout for the sear and trigger mechanism.
        // The sizing is a bit rough and ready.
        // TODO make the size of the mechanism cutout a bit more scientific.
        translate([body_length - bolt_length - mechanism_cutout_x + sear_r+sear_body_clearance, 0, floor(body_layers/2)*body_ply_thickness])
                cube([mechanism_cutout_x,mechanism_cutout_y,body_ply_thickness]);

        // This is the cutout for the bow.
        translate(bow_body_offset)
            translate([-bow_thickness,0,-body_thickness/2]) cube([bow_thickness, bow_height, body_thickness]);


        // TODO add holes to engage with the springs for the sear and trigger.
        // TODO add the bolt retention/cord guide arm.
    }
}
// This is used to slice the body into layers to be laser cut.
module body_slice(layer) {
    projection(true)
        translate([0,0,-(layer+0.5)*body_ply_thickness])
            body();
}

// This lays out all the slices of the body side by side for laser cutting.
module all_body_slices() {
    for (i = [0:body_layers-1]) {
        translate([0,i*(body_height+laser_clearance),0]) body_slice(i);
    }
}

// This arm protrudes below the body and engages with the sear.
module trigger() {
    difference() {
        cube([trigger_length, trigger_height, trigger_ply_thickness]);
        translate(trigger_shaft_offset)
            cylinder(r=trigger_shaft_r, h=trigger_ply_thickness);
    }
}
// !union() {
//     rotate([0,0,sear_trigger_angle]) trigger();
//     rotate([0,0,sear_trigger_angle]) translate(trigger_sear_offset) rotate([0,0,-sear_trigger_angle]) sear();
// }

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

// This is used to slice the bow into layers to be laser cut.
module bow_slice(layer) {
    projection(true)
        translate([0,0,-(layer+0.5)*bow_ply_thickness])
            bow();
}

// This lays out all the slices of the bow side by side for laser cutting.
module all_bow_slices() {
    for (i = [0:bow_layers-1]) {
        translate([0,i*(bow_height+laser_clearance),0]) bow_slice(i);
    }
}

// This is all the parts laid out for laser cutting
// This layout is a bit shambolic.
module all_slices() {
    all_body_slices();
    translate([0,body_layers * (body_height + laser_clearance)+laser_clearance,0])
        all_bow_slices();
    translate([sear_r*2, body_layers * (body_height + laser_clearance)+laser_clearance+sear_r+bow_height,0])
        projection()
            sear();
    translate([0,body_layers * (body_height + laser_clearance)+bow_layers * (bow_height + laser_clearance)+laser_clearance,0]) projection() trigger();
}

// This shows all the parts of the crossbow assembled for visual fit checking.
module assembled() {
    body();
    translate(sear_body_offset) union() {
        sear();
        rotate([0,0,sear_trigger_angle])
            translate(-trigger_sear_offset)
                trigger();
    }
    translate(bow_body_offset) rotate([0,-90,0]) translate([-bow_length/2,0,0]) bow();
}


// body();
// bow();

// all_slices();
assembled();