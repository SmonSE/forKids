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
    var img = false;

    hidden var mValue as Numeric;

    //getActivityInfo
    var actInfo = Activity.getActivityInfo();
    var speedRounded;

    function initialize() {
        DataField.initialize();
        mValue = 0.0f;
        myBitmap0 = WatchUi.loadResource(Rez.Drawables.snail);
        myBitmap1 = WatchUi.loadResource(Rez.Drawables.turtle);
        myBitmap2 = WatchUi.loadResource(Rez.Drawables.rabbit);
        myBitmap3 = WatchUi.loadResource(Rez.Drawables.rocket);
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
                mValue = info.currentSpeed as Number;
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
        value.setText(mValue.format("%i"));

        speedRounded = mValue.toNumber();

        Sys.println("DEBUG: drawImage() state: " + speedRounded);

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);

        // Draw Line under image
        dc.setPenWidth(2);
        dc.drawLine(dc.getWidth() / 2 -110, dc.getHeight() / 2 -15, dc.getWidth() / 2 +110, dc.getHeight() / 2 -15);

        if (speedRounded >= 0 && speedRounded <= 5) {
            Sys.println("DEBUG: drawImage() SNAIL");
            dc.drawBitmap(75,40, myBitmap0);
        }
        else if (speedRounded >= 6 && speedRounded <= 10) {
            Sys.println("DEBUG: drawImage() TURTLE");
            dc.drawBitmap(75,40, myBitmap1);
        }
        else if (speedRounded >= 11 && speedRounded <= 15) {
            Sys.println("DEBUG: drawImage() RABBIT");
            dc.drawBitmap(75,40, myBitmap2);
        }
        else if (speedRounded >= 16 && speedRounded <= 20) {
            Sys.println("DEBUG: drawImage() ROCKET");
            dc.drawBitmap(75,40, myBitmap3);
        }
        else {
            Sys.println("DEBUG: drawImage() else");

        } 

    
    }
}
