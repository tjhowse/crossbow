
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
body_ply_thickness = 2.85;
// How many layers of plywood laminated into the body. This must be an odd number.
body_layers = 5;
if (body_layers%2 != 1) {
    echo("body_layers must be an odd number.");
}
// The overall thickness of the body.
body_thickness = body_ply_thickness * body_layers;
// This is the thickness of the part of the body that wraps around the bow to hold it in place.
body_bow_retain = 6;


// Radius of the bolt fired from this crossbow. Must be less than half the material thickness of the body.
bolt_r = body_ply_thickness/2;
// This is the length of the bolt.
bolt_length = 100;

// The radius of the cord.
cord_r = 0.5;
// The radius of the sear wheel.
sear_r = 10;
// The depth of the cutout into the sear that engages with the trigger arm.
sear_trigger_notch = 3;
// The angle the trigger arm makes to the sear.
sear_trigger_angle = 25;
// The radius of the shaft through the sear.
sear_shaft_r = 2.9/2;
// This is the clearance between the sear and the body
sear_body_clearance = 0.5;

// The number of layers of plywood forming the bow.
bow_layers = 3;
// The thickness of each layer of plywood forming the bow.
bow_ply_thickness = body_ply_thickness;
// The left-to-right length of the bow when assembled.
bow_length = 200;
// The height of the bow. This shouldn't be more than half the body_height.
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
bow_body_offset = [body_length-body_bow_retain,body_height-bow_height,body_thickness/2];

// This is the overall length of the trigger.
trigger_length = 80;
// This is the height of the trigger.
trigger_height = 8;
// This is the thickness of the ply used for the trigger.
trigger_ply_thickness = body_ply_thickness;
// This is the offset between the trigger and sear module origins.
trigger_sear_offset = [trigger_length,trigger_height+sear_r-sear_trigger_notch,0];
// This is the distance from the sear end of the trigger for the trigger rotation shaft.
trigger_shaft_distance_from_sear_end = 18;
// This is the offset between the origin of the trigger module and its shaft.
trigger_shaft_offset = [trigger_length-trigger_shaft_distance_from_sear_end, trigger_height/2,0];
// This is the radius of the shaft for the trigger.
trigger_shaft_r = sear_shaft_r;

// This is the gap left between parts laid out for laser cutting.
laser_clearance = 0.5;

// This is the thickness and width of the spring material, made from a windscreen wiper blade insert.
// This material is used for the sear and trigger springs.
spring_clearance = -0.2;
spring_thickness = 0.778+spring_clearance;
spring_width = 2.5;

// This is the length of the sear spring.
sear_spring_length = 30;
trigger_spring_length = 30;

// This is the depth of the cutout in the sear to engage with the sear spring.
sear_spring_sear_cutout_depth = sear_r/2;
// This is the height of the cutout in the sear to engage with the sear spring.
sear_spring_sear_cutout_height = spring_thickness;
// This is the width of the cutout in the body to let the sear spring flex downards
sear_spring_body_cutout_width = sear_spring_length/3;
// This is the height of the cutout in the body to let the sear spring flex downards
sear_spring_body_cutout_height = sear_spring_sear_cutout_depth;
// This is how much the sear spring engages with the sear at rest. This number is not very scientific.
sear_spring_engagement_distance = sear_spring_sear_cutout_depth/2;

// This is how much the trigger spring engages with the trigger at rest. This number is not very scientific.
trigger_spring_engagement_distance = 5;
// This is the width of the cutout in the body that lets the trigger spring flex downwards.
trigger_spring_body_cutout_width = trigger_spring_length/3;
// This is the height of the cutout in the body that lets the trigger spring flex downwards.
trigger_spring_body_cutout_height = body_height/6;


// This is the height, or thickness, of the overarm that holds the bolt in place.
overarm_height = 5;
// This is the overall length of the overarm.
overarm_length = body_length/2;
// This is the vector from the overarm origin to the body origin.
overarm_body_offset = [body_length-bolt_length/2-overarm_length,body_height,0];
// This is the clearance between the overarm and the sear.
overarm_sear_clearance = 1;

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
        // This is a cutout in the sear to engage with the spring.
        translate([sear_r-sear_spring_sear_cutout_depth,-sear_spring_sear_cutout_height,0])
            cube([sear_spring_sear_cutout_depth,sear_spring_sear_cutout_height,body_ply_thickness]);
    }

}

// This is the length of the cutout section around the trigger and sear mechanism.
mechanism_cutout_x = 60;

// This is the thickness of the ply used for the pins through the body.
body_pin_ply_thickness = body_ply_thickness;
// This is the extra width to the pin to form the head.
body_pin_head_flange_x = 5;
// This is the extra width to the pin to form the head.
body_pin_head_flange_y = 4;
// This is the width of the body pin.
body_pin_width = 8;
// This is the length of the slot in the end of the body pin to allow the body cross pin through.
body_pin_slot_length = 6;
// This is the extra length of the body pin past the cross pin slot.
body_pin_past_slot = body_pin_head_flange_y;
// This is the length of the cross pin that holds the body pin in place.
body_cross_pin_length = body_ply_thickness*3;
// This is an extra little bit of length to the body cross pin to give it more flat
// surface to engage with the body pin before the taper starts.
body_cross_pin_extra_flat = 1;
// This makes the cross pin slightly tighter.
body_cross_pin_clearance = -0.3;

// These are used to pin the body together.
module body_pin() {
    // This is the head of the pin
    translate([0,-body_pin_head_flange_y/2,0])
        cube([body_pin_width + 2*body_pin_head_flange_x, body_pin_head_flange_y, body_pin_ply_thickness], center=true);
    difference () {
        // This is the main shaft of the pin.
        translate([0,(body_thickness+body_pin_slot_length+body_pin_past_slot)/2,0])
            cube([body_pin_width, body_thickness+body_pin_slot_length+body_pin_past_slot, body_pin_ply_thickness], center=true);
        // This is the cutout for the cross-pin.
        translate([0,body_pin_slot_length/2+body_thickness,0])
            cube([body_pin_ply_thickness+body_cross_pin_clearance, body_pin_slot_length, body_pin_ply_thickness], center=true);
    }
}

// This is a pin that cross-pins the body pin to lock it in place
module body_cross_pin() {
    // This is the head of the cross pin
    translate([-body_pin_ply_thickness,0,0])
        cube([body_pin_ply_thickness, body_pin_slot_length+body_pin_ply_thickness, body_pin_ply_thickness]);
    difference() {
        // This is the shaft of the cross-pin
        cube([body_cross_pin_length+body_cross_pin_extra_flat, body_pin_slot_length, body_pin_ply_thickness]);
        // This is a cut to make the cross-pin pointy and easier to go in.
        translate([body_pin_slot_length+body_pin_ply_thickness+body_cross_pin_extra_flat,0,0]) rotate([0,0,45]) cube([100,100,100]);
    }
}


// This is the body of the crossbow. It contains the trigger arm and the sear.
module body() {
    difference () {
        // Build up the body of the crossbow out of layers.
        for (i = [0:body_layers-1]) {
        // for (i = [0:body_layers-3]) {
            translate([0,0,i*body_ply_thickness]) cube([body_length, body_height, body_ply_thickness]);
        }
        // This is the groove that guides the bolt when fired.
        translate([body_length - bolt_length+zff, body_height-bolt_r+zff, floor(body_layers/2)*body_ply_thickness])
            cube([bolt_length, bolt_r*2, body_ply_thickness]);
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
        translate([body_length - bolt_length - mechanism_cutout_x + sear_r+sear_body_clearance, 0, floor(body_layers/2)*body_ply_thickness])
            union() {
                translate([mechanism_cutout_x/2,0,0]) cube([mechanism_cutout_x/2,body_height,body_ply_thickness]);
                cube([mechanism_cutout_x,body_height/2,body_ply_thickness]);
            }

        translate(sear_body_offset) union() {
            // This is the cutout to mount the sear spring
            translate([sear_spring_length/2-sear_spring_engagement_distance+sear_body_clearance, -spring_thickness,0])
                cube([sear_spring_length, spring_thickness,body_ply_thickness]);
            // This is the cutout to give the sear spring room to flex.
            translate([sear_r+sear_body_clearance,-sear_spring_body_cutout_height,0])
                cube([sear_spring_body_cutout_width, sear_spring_body_cutout_height,body_ply_thickness]);
            rotate([0,0,sear_trigger_angle]) translate(-trigger_sear_offset) translate([trigger_length-trigger_spring_engagement_distance,-spring_thickness,0])
                union() {
                    // This is the spring for the trigger.
                    cube([trigger_spring_length, spring_thickness,body_ply_thickness]);
                    // This is the cutout to give the trigger spring room to flex.
                    translate([trigger_spring_body_cutout_width/2,-trigger_spring_body_cutout_height,0])
                        cube([trigger_spring_body_cutout_width, trigger_spring_body_cutout_height,body_ply_thickness]);
                }
        }

        // This is the cutout for the bow.
        translate(bow_body_offset)
            translate([-bow_thickness,0,-body_thickness/2]) cube([bow_thickness, bow_height, body_thickness]);
        // These are pin holes for holding the body together.
        translate([0,body_height/2,0]) union() {
            // TODO make the pin hole spacing more scientific.
            translate([body_length/16,0,0]) rotate([0,0,0]) cube([body_pin_ply_thickness, body_pin_width, 100], center=true);
            translate([3*body_length/16,0,0]) rotate([0,0,90]) cube([body_pin_ply_thickness, body_pin_width, 100], center=true);
            translate([body_length - 2*body_length/16,0,0]) rotate([0,0,0]) cube([body_pin_ply_thickness, body_pin_width, 100], center=true);
            // This pin is moved down and back a bit to provide support to the trigger spring mechanism.
            translate([body_length - 4*body_length/11,-body_height/4,0]) rotate([0,0,90]) cube([body_pin_ply_thickness, body_pin_width, 100], center=true);
        }
    }

    // This is the arm over the top of the sear and bolt that holds the bolt in place
    // and guides the cord.
    translate(overarm_body_offset)
        difference() {
            cube([overarm_length, overarm_height, body_thickness]);
            // This is the cutout in the overarm to let the cord in to the sear.
            translate([overarm_length/2-cord_r*2,0,0]) cube([overarm_length/2+cord_r*2, cord_r, body_thickness]);
            // This is a cutout in the overarm to give clearance around the sear
            // to make it easier to hook the cord.
            translate(-overarm_body_offset) translate(sear_body_offset) translate([0,0,-50])
                cylinder(r=sear_r + overarm_sear_clearance, h=100);
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
        translate([0,i*(body_height+laser_clearance + overarm_height),0]) body_slice(i);
    }
}

// This arm protrudes below the body and engages with the sear.
module trigger() {
    difference() {
        // This is the main length of the trigger.
        cube([trigger_length, trigger_height, trigger_ply_thickness]);
        // This is the hole through the trigger for the shaft.
        translate(trigger_shaft_offset)
            cylinder(r=trigger_shaft_r, h=trigger_ply_thickness);
    }
}

// This is the bow attached to the front of the crossbow. It is bent with the tension of the cord.
module bow() {
    difference () {
        // This is the main body of the bow. It is made of stacked layers of decreasing length.
        for (i = [0:bow_layers-1]) {
            translate([(bow_leaf_ratio*i*bow_length)/2,0,i*bow_ply_thickness])
                cube([bow_length - bow_leaf_ratio*i*bow_length, bow_height, bow_ply_thickness]);
        }
        // This is the notch cut in the top of the bow to let the bolt through.
        translate([bow_length/2-bolt_r, bow_height-bolt_r+zff,-zff]) cube([bolt_r*2, bolt_r*2,100]);
        // These are the holes near the end of the bow to tie off the cord.
        translate([bow_cord_tie_offset,bow_height/2,-zff]) cylinder(r=cord_r*2, h=100);
        translate([bow_length - bow_cord_tie_offset,bow_height/2,-zff]) cylinder(r=cord_r*2, h=100);
        // TODO Mount the bow properly without weakening the centre.
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
    translate([0,body_layers * (body_height + overarm_height + laser_clearance)+laser_clearance,0])
        all_bow_slices();
    translate([sear_r, body_layers * (body_height + overarm_height + laser_clearance)+laser_clearance+sear_r+bow_height,0])
        projection()
            sear();
    translate([0,body_layers * (body_height + overarm_height + laser_clearance)+bow_layers * (bow_height + laser_clearance)+laser_clearance,0]) projection() trigger();
    translate([10,238,0]) pins();
}

// This lays out four of the body pins and body cross pins.
module pins() {
    projection(cut=true) {
        for (i = [0:3]) {
            translate([i*(body_pin_head_flange_x*2+body_pin_width+laser_clearance),0,0]) union() {
                body_pin();
                translate([0, 26, 0]) body_cross_pin();
            }
        }
    }
}

// This shows all the parts of the crossbow assembled for visual fit checking.
module assembled() {
    rotate([90,0,0]) union() {
        body();
        translate(sear_body_offset) union() {
            sear();
            rotate([0,0,sear_trigger_angle])
                translate(-trigger_sear_offset)
                    trigger();
        }
        translate(bow_body_offset) rotate([0,-90,0]) translate([-bow_length/2,0,0]) bow();
    }
    // TODO add the pins here.
}


// body();
// bow();

if (full_render) {
    render() !all_slices();
}
// pins();
assembled();