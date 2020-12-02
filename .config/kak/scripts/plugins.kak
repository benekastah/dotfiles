source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug "andreyorst/smarttab.kak" defer smarttab %{
    # when `backspace' is pressed, 4 spaces are deleted at once
    set global softtabstop %opt{tabstop}
} config %{
    hook global WinSetOption filetype=.* expandtab

    # these languages will use `noexpandtab' behavior
    hook global WinSetOption filetype=(makefile) noexpandtab

    hook global GlobalSetOption tabstop=.* %{
        set global softtabstop %opt{tabstop}
    }
    hook global WinSetOption tabstop=.* %{
        set window softtabstop %opt{tabstop}
    }
    hook global BufSetOption tabstop=.* %{
        set buffer softtabstop %opt{tabstop}
    }

    hook global WinSetOption filetype=yaml %{
        set window indentwidth 2
        set window tabstop 2
    }
}

plug "kak-lsp/kak-lsp" do %{
    cargo install --locked --force --path .
} config %{
    try %{
        eval %sh{kak-lsp --kakoune -s $kak_session --config ~/.config/kak/kak-lsp.toml}
    }
    hook global WinSetOption filetype=(haskell|python) %{
        lsp-enable-window
    }
}
