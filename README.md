# `dsu` (alpha)

[![GitHub version](http://badge.fury.io/gh/gangelo%2Fdsu.svg)](https://badge.fury.io/gh/gangelo%2Fdsu)
[![Gem Version](https://badge.fury.io/rb/dsu.svg)](https://badge.fury.io/rb/dsu)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/gems/dsu/)
[![Report Issues](https://img.shields.io/badge/report-issues-red.svg)](https://github.com/gangelo/dsu/issues)
[![License](http://img.shields.io/badge/license-MIT-yellowgreen.svg)](#license)

## About
`dsu` is little gem that helps manage your Agile DSU (Daily Stand Up) participation. How? by providing a simple command line interface (CLI) which allows you to create, read, update, and delete (CRUD) noteworthy activities that you performed during your day. During your DSU, you can then easily recall and share these these activities with your team. Activities are grouped by day and can be viewed in simple text format from the command line. When viewing a particular day, `dsu` will automatically display the previous day's activities as well. This is useful for remembering what you did yesterday, so you can share your "Today" and "Yesterday" activities with your team during your DSU. If the day you are trying to view falls on a weekend or Monday, `dsu` will display back to, and including the weekend and previous Friday inclusive, so that you can share what you did over the weekend (if anything) and the previous Friday.

**NOTE:** This gem is in development (alpha version). Please see the [WIP Notes](#wip-notes) section for current `dsu` features.

## Quick Start

After installation (`gem install dsu`), the first thing you may want to do is run the `dsu` help:
### Displaying Help
`$ dsu` or `$ dsu help`
```shell
#=>
Commands:
  dsu add, -a [OPTIONS] DESCRIPTION  # Adds a DSU entry having DESCRIPTION to the date associated with the given OPTION
  dsu config, -c SUBCOMMAND          # Manage configuration...
  dsu edit, -e SUBCOMMAND            # Edit DSU entries...
  dsu help [COMMAND]                 # Describe available...
  dsu list, -l SUBCOMMAND            # Displays DSU entries...
  dsu version, -v                    # Displays this gem version

Options:
  [--debug], [--no-debug]
```

The next thing you may want to do is `add` some DSU activities (entries) for a particular day:

### Adding DSU Entries
`dsu add [OPTIONS] DESCRIPTION`

Adding DSU entry using this command will _add_ the DSU entry for the given day (or date, `-d`), and also _display_ the given day's (or date's, `-d`) DSU entries, as well as the DSU entries for the previous day relative to the given day or date (`-d`).

#### Today
If you need to add a DSU entry to the current day (today), you can use the `-t, [--today]` option. Today (`-t`) is the default; therefore, the `-t` flag is optional when adding DSU entries for the current day:

`$ dsu add [-t] "Pair with John on ticket IN-12345"`

#### Yesterday
If for some reason you need to add a DSU entry for the previous day, you can use the `-p, [--previous-day]` option:

`$ dsu add -p "Pick up ticket IN-12345"`

#### Tomorrow
If you need to add a DSU entry for the previous day, you can use the `-n, [--next-day]` option:

`$ dsu add -n "Pick up ticket IN-12345"`

#### Miscellaneous Date
If you need to add a DSU entry for a date other than yesterday, today or tomorrow, you can use the `-d, [--date=DATE]` option, where DATE is any date string that can be parsed using `Time.parse`. For example: `require 'time'; Time.parse("2023-01-01")`:

`$ dsu add -d "2022-12-31" "Attend company New Years Coffee Meet & Greet"`

### Displaying DSU Entries
You can display DSU entries for a particular day or date (`date`) using any of the following commands. When displaying DSU entries for a particular day or date (`date`), `dsu` will display the given day or date's (`date`) DSU entries, as well as the DSU entries for the _previous_ day, relative to the given day or date. If the date or day you are trying to view falls on a weekend or Monday, `dsu` will display back to, and including the weekend and previous Friday inclusive; this is so that you can share what you did over the weekend (if anything) and the previous Friday at your DSU:

- `$ dsu list today|n`
- `$ dsu list tomorrow|t`
- `$ dsu list yesterday|y`
- `$ dsu list date|d DATE`

#### Examples
The following displays the entries for "Today", where `Time.now == '2023-05-06 08:54:57.6861 -0400'`

`$ dsu list today`
```shell
#=>
Saturday, (Today) 2023-05-06
  1. 587a2f29 Blocked for locally failing test IN-12345
              Hope to pair with John on it

Friday, (Yesterday) 2023-05-05
  1. edc25a9a Pick up ticket IN-12345
  2. f7d3018c Attend new hire meet & greet
```

`$ dsu list date "2023-05-06"`

Where DATE may be any date string that can be parsed using `Time.parse`. Consequently, you may use also use '/'' as date separators, as well as omit thee year if the date you want to display is the current year (e.g. <month>/<day>, or 1/31). For example: `require 'time'; Time.parse('2023-01-02'); Time.parse('1/2') # etc.`:

```shell
#=>
Saturday, (Today) 2023-05-06
  1. 587a2f29 Blocked for locally failing test IN-12345
              Hope to pair with John on it

Friday, (Yesterday) 2023-05-05
  1. edc25a9a Pick up ticket IN-12345
  2. f7d3018c Attend new hire meet & greet
```

### Customizing the `dsu` Configuration File

It is **not** recommended that you create and customize a `dsu` configuration file while this gem is in alpha release. This is because changes to what configuration options are available may take place while in alpha that could break `dsu`. If you *do* want to create and customize the `dsu` configuration file reglardless, you may do the following.

#### Initializing/Customizing the `dsu` Configuration File

```shell
# Creates a dsu configuration file in your home folder.
$ dsu config init

#=>
Configuration file (/Users/<whoami>/.dsu) created.
Config file (/Users/<whoami>/.dsu) contents:
---
entries_display_order: desc
entries_file_name: "%Y-%m-%d.json"
entries_folder: "/Users/<whoami>/dsu/entries"
```

Where `<whoami>` would be your username (`$ whoami` on nix systems)

Once the configuration file is created, you can locate where the `dsu` configuration file is located by running `$ dsu config info` and taking note of the confiruration file path. You may then edit this file using your favorite editor.

##### Configuration File Options
###### entries_display_order
Valid values are 'asc' and 'desc', and will sort listed DSU entries in ascending or descending order respectfully, by day.

Default: `'desc'`

###### entries_file_name
The entries file name format. It is recommended that you do not change this. The file name must include `%Y`, `%m` and `%d` `Time` formatting specifiers to make sure the file name is unique and able to be located by `dsu` functions. For example, the default file name is `%Y-%m-%d.json`; however, something like `%m-%d-%Y.json` or `entry-group-%m-%d-%Y.json` would work as well.

ATTENTION: Please keep in mind that if you change this value `dsu` will not recognize entry files using a different format. You would (at this time), have to manually rename any existing entry file names to the new format.

Default: `'%Y-%m-%d.json'`

###### entries_folder
This is the folder where `dsu` stores entry files. You may change this to anything you want. `dsu` will create this folder for you, as long as your system's write permissions allow this.

ATTENTION: Please keep in mind that if you change this value `dsu` will not be able to find entry files in any previous folder. You would (at this time), have to manually mode any existing entry files to this new folder.

Default: `'/Users/<whoami>/dsu/entries'` on nix systems.

Where `<whoami>` would be your username (`$ whoami` on nix systems)

## WIP Notes
This gem is in development (alpha release) and currently does not provide the ability to UPDATE or DELETE activities. These features will be added in future releases.

## Installation

    $ gem install dsu

## Usage

TODO: Write usage instructions here (see the [Quick Start](#quick-start) for now)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gangelo/dsu. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/dsu/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dsu project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dsu/blob/main/CODE_OF_CONDUCT.md).
