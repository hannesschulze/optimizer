<div align="center">
  <span align="center"> <img width="80" height="70" class="center" src="data/images/icons/64/com.github.hannesschulze.optimizer.svg" alt="Icon"></span>
  <h1 align="center">Optimizer</h1>
  <h3 align="center">Find out what's eating up your system resources and delete unnecessary files from your disk.</h3>
</div>

<br/>

<img  src="data/screenshot1.png" alt="Screenshot"> <br>

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
    <img src="https://img.shields.io/badge/Release-v%201.1.0-orange.svg">
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
 - `libgtop2-dev`
 - `libwnck-3-dev`


Use the following command to install the dependencies:
```shell
sudo apt install elementary-sdk libgtop2-dev libwnck-3-dev
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

### Credits

- **Stacer:** This project is heavily inspired by [Stacer](https://oguzhaninan.github.io/Stacer-Web/) (written in Qt). Optimizer aims to provide some of the features in an elementary app with native Gtk widgets.
- **Monitor:** Some of the logic for the process list is from [Monitor](https://github.com/stsdc/monitor), which is another elementary app. Optimizer is using some of the code in a simplified version - other than Monitor it just uses a process list instead of a neat tree view. Definitely check out this project if you want a monitor!

### License

This project is licensed under the GPL-3.0 License - see the [COPYING](COPYING) file for details.
