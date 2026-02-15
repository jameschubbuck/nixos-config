{pkgs ? import <nixpkgs> {}}: let
  pythonEnv = pkgs.python3.withPackages (p: [p.pygobject3]);

  script = pkgs.writeScript "monitor-control-script" ''
    #!${pythonEnv}/bin/python3
    import gi
    import subprocess
    import sys

    gi.require_version('Gtk', '4.0')
    gi.require_version('Adw', '1')
    from gi.repository import Gtk, Adw, GLib, Gdk

    # Global dictionary to track debounce timers
    timers = {}

    def run_ddc_command(feature, value):
        """Helper to actually run the subprocess."""
        cmd = ['${pkgs.ddcutil}/bin/ddcutil', 'setvcp', str(feature), str(int(value))]
        print(f"Sending: Feature {feature} -> {value}")
        subprocess.Popen(cmd)

    def send_command_delayed(feature, value):
        """Callback for the timer."""
        run_ddc_command(feature, value)
        if feature in timers:
            del timers[feature]
        return False

    def on_change(scale, feature):
        """Handles the drag/value change event (Debounced)."""
        val = scale.get_value()
        if feature in timers:
            GLib.source_remove(timers[feature])
        timers[feature] = GLib.timeout_add(150, send_command_delayed, feature, val)

    def on_release(gesture, n_press, x, y, scale, feature):
        """Handles the mouse release event (Immediate)."""
        val = scale.get_value()
        if feature in timers:
            GLib.source_remove(timers[feature])
            del timers[feature]
        run_ddc_command(feature, val)

    def load_css():
        """Injects custom CSS for visual refinements."""
        css_provider = Gtk.CssProvider()

        css = b"""
        headerbar {
            border-bottom: 1px solid alpha(currentColor, 0.15);
            background-color: @headerbar_bg_color;
            min-height: 46px;
        }

        window {
            background-color: @view_bg_color;
        }

        .footer-label {
            opacity: 0.4;
            font-size: 0.75rem;
            margin-top: 12px;
            margin-bottom: 12px;
        }
        """

        css_provider.load_from_data(css)
        Gtk.StyleContext.add_provider_for_display(
            Gdk.Display.get_default(),
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

    def create_slider_row(title, icon_name, feature_code):
        row = Adw.ActionRow()
        row.set_title(title)
        row.set_icon_name(icon_name)

        scale = Gtk.Scale.new_with_range(Gtk.Orientation.HORIZONTAL, 0, 100, 1)
        scale.set_value(50)

        # --- ALIGNMENT FIX ---
        # 1. Disable hexpand so it doesn't grow based on available space left by text.
        scale.set_hexpand(False)
        # 2. Set a fixed width so all sliders are identical in size.
        scale.set_size_request(220, -1)
        # 3. Align to the END (Right) so they anchor to the right edge.
        scale.set_halign(Gtk.Align.END)
        scale.set_valign(Gtk.Align.CENTER)

        scale.add_css_class("accent")

        scale.connect('value-changed', on_change, feature_code)

        gesture = Gtk.GestureClick()
        gesture.set_button(0)
        gesture.set_propagation_phase(Gtk.PropagationPhase.CAPTURE)
        gesture.connect('released', on_release, scale, feature_code)
        scale.add_controller(gesture)

        row.add_suffix(scale)
        return row

    def create_footer():
        """Creates the footer label."""
        label = Gtk.Label(label="Made with ❤️ in California")
        label.add_css_class("footer-label")
        return label

    def on_activate(app):
        load_css()

        win = Adw.ApplicationWindow(application=app)
        win.set_title("Monitor Control")
        win.set_default_size(520, 260)

        view = Adw.ToolbarView()
        win.set_content(view)

        header = Adw.HeaderBar()
        header.remove_css_class("flat")
        view.add_top_bar(header)

        page = Adw.PreferencesPage()
        group = Adw.PreferencesGroup()

        # Note: Title and Description removed as requested.

        page.add(group)
        view.set_content(page)

        # Add Controls
        group.add(create_slider_row("Brightness", "display-brightness-symbolic", 10))
        group.add(create_slider_row("Contrast", "weather-clear-night-symbolic", 12))

        # Add Footer to the bottom bar of the view
        view.add_bottom_bar(create_footer())

        win.present()

    app = Adw.Application(application_id="com.nixos.monitorcontrol")
    app.connect('activate', on_activate)
    app.run(sys.argv)
  '';
in
  pkgs.stdenv.mkDerivation {
    pname = "monitor-control";
    version = "1.2.2";

    dontUnpack = true;

    nativeBuildInputs = [
      pkgs.wrapGAppsHook4
      pkgs.gobject-introspection
    ];

    buildInputs = [
      pkgs.gtk4
      pkgs.libadwaita
      pythonEnv
    ];

    installPhase = ''
      mkdir -p $out/bin $out/share/applications
      cp ${script} $out/bin/monitor-control
      chmod +x $out/bin/monitor-control

      cat > $out/share/applications/monitor-control.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=Monitor Control
      Comment=Adjust Brightness and Contrast via DDC/CI
      Exec=$out/bin/monitor-control
      Icon=display-brightness-symbolic
      Terminal=false
      Categories=Settings;HardwareSettings;
      Keywords=brightness;contrast;monitor;
      EOF
    '';
  }
