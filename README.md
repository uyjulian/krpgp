# PGP plugin for Kirikiri

This plugin allows the usage of PGP functions in Kirikiri / 吉里吉里

## Building

After cloning submodules and placing `ncbind` and `tp_stub` in the parent directory, a simple `make` will generate `krpgp.dll`.

## How to use

After `Plugins.link("krpgp.dll");` is used, the krpgp interface will be exposed under the `krpgp` class.

## License

This project is licensed under the MIT license. Please read the `LICENSE` file for more information.
