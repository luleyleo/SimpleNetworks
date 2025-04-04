/* window.vala
 *
 * Copyright 2025 Leopold Luley
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

public class SN.Connection : GLib.Object {
    public string ssid { get; private set; default = "UNDEFINED"; }
    public bool is_active { get; private set; default = false; }
    
    public Connection (NM.RemoteConnection conn) {
        var settings = conn.get_setting_wireless();
        this.ssid = (string)settings.ssid.get_data();
    }
}

public class SN.AccessPoint : GLib.Object {
    public bool is_active { get; private set; }
    public NM.AccessPoint nm { get; private set; }
    
    public AccessPoint (NM.AccessPoint ap, bool is_active) {
        this.is_active = is_active;
        this.nm = ap;
    }
}

[GtkTemplate (ui = "/de/leopoldluley/SimpleNetworks/window.ui")]
public class SN.Window : Adw.ApplicationWindow {
    private NM.Client nm_client;
    private NM.DeviceWifi nm_wifi;
    
    private GLib.ListStore connections = new GLib.ListStore(typeof(SN.AccessPoint));

    [GtkChild]
    private unowned Gtk.ListView list_view;

    public Window (Gtk.Application app) {
        typeof(AccessPointListItem).ensure();
        Object(application: app);
    }
    
    construct {
        this.nm_client = new NM.Client();
        
        foreach (NM.Device device in this.nm_client.devices) {
            if (device.device_type == NM.DeviceType.WIFI) {
                this.nm_wifi = (NM.DeviceWifi)device;
                stdout.printf("WIFI device found\n");
                break;
            }
        }
        
        this.list_view.model = new Gtk.NoSelection(this.connections);
        
        this.scan_access_points();
    }
    
    [GtkCallback]
    private void on_reload_button_clicked(Gtk.Button button) {
        this.scan_access_points();
    }
    
    private void scan_access_points() {
        stdout.printf("Starting scan...\n");
        var nm_wifi = this.nm_wifi;
        var active = nm_wifi.active_access_point;
        nm_wifi.request_scan_async.begin(null, (obj, res) => {
            stdout.printf("Scan complete\n");
            this.connections.remove_all();
            foreach (NM.AccessPoint nm_ap in this.nm_wifi.access_points) {
                if (nm_ap.ssid == null) continue;
                var sn_ap = new SN.AccessPoint(nm_ap, nm_ap == active);
                this.connections.append(sn_ap);
            }
            stdout.printf("Found %u access points\n", this.connections.n_items);
        });
    }
}
