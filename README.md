# frmad

## dependencies
- lua >= 5.1
- luarocks
- minilib https://github.com/bucketsize/minilib

## install
Clone this repo, and from toplevel:

`luarocks make --local` #installs to ~/.luarocks

Run
- `~/.luarocks/bin/frmad.cached - - ` 
- `~/.luarocks/bin/frmad.daemon`
- `~/.luarocks/bin/frmad.i3status_out`

## uninstall
`luarocks remove frmad --local` #removes from ~/.luarocks
