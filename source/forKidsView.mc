import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

using Toybox.System as Sys;

class forKidsView extends WatchUi.DataField {

    var myBitmap0;
    var myBitmap1;
    var myBitmap2;
    var myBitmap3;
    var myBitmap4;
    var myBitmap5;
    var img = false;
    var starX = 20;
    var starY = 210;

    hidden var sValue as Numeric;
    hidden var mValue as Numeric;

    //getActivityInfo
    var actInfo = Activity.getActivityInfo();
    var speedRounded;
    var distanceRounded;

    function initialize() {
        DataField.initialize();
        sValue = 0.0f;
        mValue = 0.0f;
        myBitmap0 = WatchUi.loadResource(Rez.Drawables.snail);
        myBitmap1 = WatchUi.loadResource(Rez.Drawables.turtle);
        myBitmap2 = WatchUi.loadResource(Rez.Drawables.rabbit);
        myBitmap3 = WatchUi.loadResource(Rez.Drawables.rocket);
        myBitmap4 = WatchUi.loadResource(Rez.Drawables.sleep);
        myBitmap5 = WatchUi.loadResource(Rez.Drawables.star);
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void {
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("label");
            labelView.locY = labelView.locY - 16;
            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY + 7;
            var distanceView = View.findDrawableById("distance");
            distanceView.locY = distanceView.locY + 130;
        }

        (View.findDrawableById("label") as Text).setText(Rez.Strings.label);
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {
        // See Activity.Info in the documentation for available information.
        if(info has :currentSpeed){
            if(info.currentSpeed != null){
                sValue = info.currentSpeed as Number * 3.6;     // from mps to kmh
                Sys.println("DEBUG: currentSpeed() " + sValue.toNumber());
            } else {
                sValue = 0.0f;
                Sys.println("DEBUG: currentSpeed() " + sValue.toNumber());
            }
        }

        // Distance
        if(info has :elapsedDistance){
            Sys.println("DEBUG: drawImage() elapsedDistance");
            if(info.elapsedDistance != null){
                mValue = info.elapsedDistance as Number / 1000; // from m to km
                Sys.println("DEBUG: elapsedDistance() " + mValue.toNumber());
            } else {
                mValue = 0.0f;
                Sys.println("DEBUG: elapsedDistance() " + mValue.toNumber());
            }
        }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        // Set the background color
        (View.findDrawableById("Background") as Text).setColor(getBackgroundColor());

        // Set the foreground color and value
        var value = View.findDrawableById("value") as Text;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            value.setColor(Graphics.COLOR_WHITE);
        } else {
            value.setColor(Graphics.COLOR_BLACK);
        }
        value.setText(sValue.format("%i") + " km/h");

        var distance = View.findDrawableById("distance") as Text;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            distance.setColor(Graphics.COLOR_WHITE);
        } else {
            distance.setColor(Graphics.COLOR_BLACK);
        }
        distance.setText(mValue.format("%i") + " km");
        
        speedRounded = sValue.toNumber();
        Sys.println("DEBUG: drawImage() state: " + speedRounded);

        distanceRounded = mValue.toNumber();
        Sys.println("DEBUG: drawImage() state: " + distanceRounded);


        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);

        // ----------------------------------------------------------- //

        // Draw Line under image
        dc.setPenWidth(2);
        dc.drawLine(dc.getWidth() / 2 -110, dc.getHeight() / 2 -15, dc.getWidth() / 2 +110, dc.getHeight() / 2 -15);
        dc.drawLine(dc.getWidth() / 2 -110, dc.getHeight() / 2 +35, dc.getWidth() / 2 +110, dc.getHeight() / 2 +35);
        dc.drawLine(dc.getWidth() / 2 -110, dc.getHeight() / 2 +110, dc.getWidth() / 2 +110, dc.getHeight() / 2 +110);

        if (speedRounded >= 1 && speedRounded <= 7) {
            //Sys.println("DEBUG: drawImage() SNAIL");
            dc.drawBitmap(75,35, myBitmap0);
        }
        else if (speedRounded >= 8 && speedRounded <= 14) {
            //Sys.println("DEBUG: drawImage() TURTLE");
            dc.drawBitmap(75,35, myBitmap1);
        }
        else if (speedRounded >= 15 && speedRounded <= 21) {
            //Sys.println("DEBUG: drawImage() RABBIT");
            dc.drawBitmap(75,35, myBitmap2);
        }
        else if (speedRounded > 21 ) {
            //Sys.println("DEBUG: drawImage() ROCKET");
            dc.drawBitmap(75,35, myBitmap3);
        }
        else {
            //Sys.println("DEBUG: drawImage() SLEEP");
            dc.drawBitmap(75,35, myBitmap4);
        } 

        if (distanceRounded != 0) {
            if (distanceRounded == 1) {
                dc.drawBitmap(starX,starY, myBitmap5);
            } else if (distanceRounded == 2) {
                dc.drawBitmap(starX,starY, myBitmap5);
                dc.drawBitmap(starX + 40,starY, myBitmap5);
            } else if (distanceRounded == 3) {
                dc.drawBitmap(starX,starY, myBitmap5);
                dc.drawBitmap(starX + 40,starY, myBitmap5);
                dc.drawBitmap(starX + 80,starY, myBitmap5);
            } else if (distanceRounded == 4) {
                dc.drawBitmap(starX,starY, myBitmap5);
                dc.drawBitmap(starX + 40,starY, myBitmap5);
                dc.drawBitmap(starX + 80,starY, myBitmap5);
                dc.drawBitmap(starX + 120,starY, myBitmap5);
            } else if (distanceRounded == 5) {
                dc.drawBitmap(starX,starY, myBitmap5);
                dc.drawBitmap(starX + 40,starY, myBitmap5);
                dc.drawBitmap(starX + 80,starY, myBitmap5);
                dc.drawBitmap(starX + 120,starY, myBitmap5);
                dc.drawBitmap(starX + 160,starY, myBitmap5);
            } else {
                Sys.println("DEBUG: drawBitmap() NOTHING");
            }
        }    
    }
}
