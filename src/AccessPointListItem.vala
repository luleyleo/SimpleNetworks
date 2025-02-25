[GtkTemplate (ui = "/de/leopoldluley/SimpleNetworks/AccessPointListItem.ui")]
public class SN.AccessPointListItem : Gtk.Widget {
    public NM.AccessPoint? access_point { get; set; }
    
    [GtkChild]
    public unowned Adw.ActionRow container;
    
    public string ssid { get; private set; }
    public string frequency { get; private set; }
    public string strength { get; private set; }
    public string subtitle { get; private set; }
    
    construct {
        this.notify["access-point"].connect((ap, p) => {
            this.ssid = (string)access_point.ssid.get_data();
            this.frequency = access_point.frequency < 3000 ? "2.4 GHz" : "5 GHz";
            int strength = (int)(((double)access_point.strength) / 255 * 100);
            this.strength = @"$strength %";
            this.subtitle = @"$(this.frequency) - $(this.strength)";
        });
    }
    
    public override void dispose() {
        this.container.unparent();
        base.dispose();
    }
}
