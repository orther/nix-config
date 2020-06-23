self: super {
  yabai = super.yabai.overrideAttrs (
    o: {
      version = "master";
      src = super.fetchFromGitHub {
        owner = "koekeishiya";
        repo = "yabai";
        rev = "17fcfb73d8bc013b0250a9be42adb91c1a7cb72e";
        sha256 = "065qdf5q955jr2cic47w0nxmp8n13dvjpmi6b779kggr38b1l7wz";
      };
    }
  );
}
