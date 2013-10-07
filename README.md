## LED Control
This is a source code for LED Control.

[Original website](http://stylemistake.com/led.html)


***

### Prerequisites
You need:
* Erlang R16B02 (erts-5.10.3)
* Arduino IDE

You can get latest Erlang on [erlang-solutions.com](https://www.erlang-solutions.com/).

That's it. :)


***

### Compile
```
git clone https://github.com/stylemistake/ledctl.git
cd ledctl
./bootstrap.sh
make
```

To run:
```
./launch.sh
```
To generate a release:
```
make release
```

Arduino firmware source is in `blinker/blinker.ino`


***

### Contacts

Email: stylemistake@gmail.com
Web: [stylemistake.com](http://stylemistake.com)
