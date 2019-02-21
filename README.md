<div align="center">
  <span align="center"> <img width="80" height="70" class="center" src="data/images/icons/64/com.github.hannesschulze.optimizer.svg" alt="Icon"></span>
  <h1 align="center">Optimizer</h1>
  <h3 align="center">Show currently open applications, monitor CPU, memory and network usage and clean up your system</h3>
</div>

<br/>

<p align="center">
    <a href="https://appcenter.elementary.io/com.github.hannesschulze.optimizer">
        <img src="https://appcenter.elementary.io/badge.svg">
    </a>
</p>

<p align="center">
  <a href="https://github.com/hannesschulze/optimizer/blob/master/COPYING">
    <img src="https://img.shields.io/badge/License-GPL--3.0-blue.svg">
  </a>
  <a href="https://github.com/hannesschulze/optimizer/releases">
    <img src="https://img.shields.io/badge/Release-v%201.0.0-orange.svg">
  </a>
</p>

<p align="center">
  <a href="https://github.com/hannesschulze/optimizer/issues/new"> Report a problem! </a>
</p>

## Installation

### Dependencies
These dependencies must be present before building:
 - `meson`
 - `valac`
 - `debhelper`
 - `libgranite-dev`
 - `libgtk-3-dev`


Use the following command to install the dependencies:
```shell
sudo apt install elementary-sdk
```
 
### Building

```
git clone https://github.com/hannesschulze/optimizer.git && cd optimizer
meson build --prefix=/usr
cd build
ninja
```

To install, use `ninja install`, then execute with `com.github.hannesschulze.optimizer`:

```shell
sudo ninja install
com.github.hannesschulze.optimizer
```

### License

This project is licensed under the GPL-3.0 License - see the [COPYING](COPYING) file for details.