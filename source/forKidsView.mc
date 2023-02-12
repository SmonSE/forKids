import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

using Toybox.System as Sys;
using Toybox.Application as App;

class forKidsView extends WatchUi.DataField {

    var myBitmap0, myBitmap1, myBitmap2, myBitmap3; 
    var myBitmap4, myBitmap5, myBitmap6, myBitmap7;
    var myBitmap8, myBitmap9, myBitmap10, myBitmap11;
    var myBitmap12, myBitmap13, myBitmap14, myBitmap15;
    var starX = 20;
    var starY = 210;

    hidden var sValue as Numeric;
    hidden var mValue as Numeric;

    //getActivityInfo
    var actInfo = Activity.getActivityInfo();
    var speedRounded;
    var distanceRounded;

    // load the zones from app properties 
    var zone_1 = DataManager.getZone1();
    var zone_2 = DataManager.getZone2();
    var zone_3 = DataManager.getZone3();

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
        myBitmap6 = WatchUi.loadResource(Rez.Drawables.starBlack);
        myBitmap7 = WatchUi.loadResource(Rez.Drawables.trophy);
        
        myBitmap8 = WatchUi.loadResource(Rez.Drawables.rabbitw);
        myBitmap9 = WatchUi.loadResource(Rez.Drawables.sleepw);
        myBitmap10 = WatchUi.loadResource(Rez.Drawables.rocketw);
        myBitmap11 = WatchUi.loadResource(Rez.Drawables.snailw);
        myBitmap12 = WatchUi.loadResource(Rez.Drawables.turtlew);
        myBitmap13 = WatchUi.loadResource(Rez.Drawables.starw);
        myBitmap14 = WatchUi.loadResource(Rez.Drawables.starBlackw);
        myBitmap15 = WatchUi.loadResource(Rez.Drawables.trophyw);
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
            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY + 7;
            var distanceView = View.findDrawableById("distance");
            distanceView.locY = distanceView.locY + 130;
        }
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
            } else {
                sValue = 0.0f;
            }
        }

        // Distance
        if(info has :elapsedDistance){
            //Sys.println("DEBUG: drawImage() elapsedDistance");
            if(info.elapsedDistance != null){
                mValue = info.elapsedDistance as Number / 1000; // from m to km
            } else {
                mValue = 0.0f;
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
        //Sys.println("DEBUG: drawImage() state: " + speedRounded);

        distanceRounded = mValue.toNumber();
        //Sys.println("DEBUG: drawImage() state: " + distanceRounded);


        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);

        // ----------------------------------------------------------- //

        // Draw Line under image
        dc.setPenWidth(2);
        dc.drawLine(dc.getWidth() / 2 -110, dc.getHeight() / 2 -15, dc.getWidth() / 2 +110, dc.getHeight() / 2 -15);
        dc.drawLine(dc.getWidth() / 2 -110, dc.getHeight() / 2 +35, dc.getWidth() / 2 +110, dc.getHeight() / 2 +35);
        dc.drawLine(dc.getWidth() / 2 -110, dc.getHeight() / 2 +110, dc.getWidth() / 2 +110, dc.getHeight() / 2 +110);

        if (speedRounded >= 1 && speedRounded <= zone_1) {              // 1-5 km/h
            //Sys.println("DEBUG: drawImage() SNAIL");
            if(getBackgroundColor() == Graphics.COLOR_BLACK) {
                dc.drawBitmap(75,35, myBitmap11);
            }
            else {
                dc.drawBitmap(75,35, myBitmap0);
            }
        }
        else if (speedRounded > zone_1 && speedRounded <= zone_2) {     // 6-10 km/h
            //Sys.println("DEBUG: drawImage() TURTLE");
            if(getBackgroundColor() == Graphics.COLOR_BLACK) {
                dc.drawBitmap(75,35, myBitmap12);
            }
            else {
                dc.drawBitmap(75,35, myBitmap1);
            }
        }
        else if (speedRounded > zone_2 && speedRounded <= zone_3) {     // 11-15 km/h
            //Sys.println("DEBUG: drawImage() RABBIT");
            if(getBackgroundColor() == Graphics.COLOR_BLACK) {
                dc.drawBitmap(75,35, myBitmap8);
            }
            else {
                dc.drawBitmap(75,35, myBitmap2);
            }
        }
        else if (speedRounded > zone_3 ) {                              // 16 km/h
            //Sys.println("DEBUG: drawImage() ROCKET");
            if(getBackgroundColor() == Graphics.COLOR_BLACK) {
                dc.drawBitmap(75,35, myBitmap10);
            }
            else {
                dc.drawBitmap(75,35, myBitmap3);
            }
        }
        else {
            //Sys.println("DEBUG: drawImage() SLEEP");                  // 0 km/h
            if(getBackgroundColor() == Graphics.COLOR_BLACK) {
                dc.drawBitmap(75,35, myBitmap9);
            }
            else {
                dc.drawBitmap(75,35, myBitmap4);
            }
        } 


        var starBitmap = myBitmap5;
        if( getBackgroundColor() == Graphics.COLOR_BLACK) {
            starBitmap = myBitmap12;
        }
        
        var starBlackBitmap = myBitmap6;
        if( getBackgroundColor() == Graphics.COLOR_BLACK) {
            starBlackBitmap = myBitmap14;
        }

        if (distanceRounded != 0) {
            if (distanceRounded <= 10) {
                switch ( distanceRounded ) {
                    case 1: {
                        dc.drawBitmap(starX,starY, starBitmap);
                        break;
                    }
                    case 2: {
                        dc.drawBitmap(starX,starY, starBitmap);
                        dc.drawBitmap(starX + 40,starY, starBitmap);
                        break;
                    }
                    case 3: {
                        dc.drawBitmap(starX,starY, starBitmap);
                        dc.drawBitmap(starX + 40,starY, starBitmap);
                        dc.drawBitmap(starX + 80,starY, starBitmap);
                        break;
                    }
                    case 4: {
                        dc.drawBitmap(starX,starY, starBitmap);
                        dc.drawBitmap(starX + 40,starY, starBitmap);
                        dc.drawBitmap(starX + 80,starY, starBitmap);
                        dc.drawBitmap(starX + 120,starY, starBitmap);
                        break;
                    }
                    case 5: {
                        dc.drawBitmap(starX,starY, starBitmap);
                        dc.drawBitmap(starX + 40,starY, starBitmap);
                        dc.drawBitmap(starX + 80,starY, starBitmap);
                        dc.drawBitmap(starX + 120,starY, starBitmap);
                        dc.drawBitmap(starX + 160,starY, starBitmap);
                        break;
                    }
                    case 6: {
                        dc.drawBitmap(starX,starY, starBlackBitmap);
                        break;
                    }
                    case 7: {
                        dc.drawBitmap(starX,starY, starBlackBitmap);
                        dc.drawBitmap(starX + 40,starY, starBlackBitmap);
                        break;
                    }
                    case 8: {
                        dc.drawBitmap(starX,starY, starBlackBitmap);
                        dc.drawBitmap(starX + 40,starY, starBlackBitmap);
                        dc.drawBitmap(starX + 80,starY, starBlackBitmap);
                        break;
                    }
                    case 9: {
                        dc.drawBitmap(starX,starY, starBlackBitmap);
                        dc.drawBitmap(starX + 40,starY, starBlackBitmap);
                        dc.drawBitmap(starX + 80,starY, starBlackBitmap);
                        dc.drawBitmap(starX + 120,starY, starBlackBitmap);
                        break;
                    }
                    case 10: {
                        dc.drawBitmap(starX,starY, starBlackBitmap);
                        dc.drawBitmap(starX + 40,starY, starBlackBitmap);
                        dc.drawBitmap(starX + 80,starY, starBlackBitmap);
                        dc.drawBitmap(starX + 120,starY, starBlackBitmap);
                        dc.drawBitmap(starX + 160,starY, starBlackBitmap);
                        break;
                    }
                    default: {
                        Sys.println("DEBUG: drawBitmap() NOTHING");
                        break;
                    }
                }
            } else {
                if( getBackgroundColor() == Graphics.COLOR_BLACK) {
                    dc.drawBitmap(starX +80,starY -5, myBitmap15);
                }
                else {
                    dc.drawBitmap(starX +80,starY -5, myBitmap7);
                }
            }
        }    
    }
}
