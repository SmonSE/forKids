import Toybox.Application;

class DataManager {
    static function getZone1() {
        return Application.Properties.getValue("zone1");
    }

    static function setZone1(zone) {
        Application.Properties.setValue("zone1", zone);
    }

    static function getZone2() {
        return Application.Properties.getValue("zone2");
    }

    static function setZone2(zone) {
        Application.Properties.setValue("zone2", zone);
    }

        static function getZone3() {
        return Application.Properties.getValue("zone3");
    }

    static function setZone3(zone) {
        Application.Properties.setValue("zone3", zone);
    }
}
