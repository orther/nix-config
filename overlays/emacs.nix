self:
super {
  emacsGcc = import (
    super.fetchTarball {
      url =
        "https://github.com/mjlbach/emacs-pgtk-nativecomp-overlay/archive/master.tar.gz";
    }
  );
}
