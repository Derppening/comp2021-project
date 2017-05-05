# Bob 

A Perl-based framework for text-based role-playing game, supporting non-linear
gameplay.

## Getting Started

These instructions will set your project up and running on your local machine.

### Prerequisites

* [Perl Interpreter](https://www.perl.org/get.html)
* [Perl Term::ReadKey Module](http://search.cpan.org/~jstowe/TermReadKey-2.37/ReadKey_pm.PL)
    * Run `cpan Term::ReadKey` in a command line to install the module

### Running

In the project root, run the following command:
```
perl main.pl --version
```

The output should look something like this:
```
Bob 1.0.0
```

If you see the above output, you're ready to go!

#### Can't Locate `<module>.pm`

If an error similar to the following occurs:
```
Can't locate Term/ReadKey.pm in @INC (you may need to install the Term::ReadKey
module)
```

Try to run `cpan <module>` to install the missing module(s).

## Usage

To run the framework in normal mode:
```
perl main.pl [FILE]
```

To run the framework in creator mode:
```
perl main.pl --creator [FILE]
```

Under both modes, if `[FILE]` is not specified, the framework will prompt the 
user during runtime.

For command-line arguments, see `perl main.pl --help`

## Versioning

Currently, version number will simply be `Internal Build` followed by the build
date.

Upon public release (i.e. the date of presentation), 
[SemVer](http://semver.org/) will be used.

## Authors

* **David Mak** - Plot Reader, Creator Mode - 
[Derppening](https://github.com/Derppening)
* **Jackson Lau** - Gameplay Interface, Response Processing - 
[yflauaa](https://github.com/yflauaa)
* **Klara Matsson** - Save/Load Game Feature, Sample Game - 
[aoifee](https://github.com/aoifee)

## License

We'll figure that out later.

## Acknowledgements

* COMP2021 Teaching Staff, for making this project possible (in Perl).
* COMP2021 Students, for your support of this project <3
