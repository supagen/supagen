# Supagen (Supabase Generator)

## Introduction
A CLI tool to automate manual effort/repetitive things when using Supabase.

## Key Objectives
- Automate manual effort/repetitive things
- Make your life easier when using supabase

## Features

- Init supabase client project using selected template
- Generate and update models and CRUD functionality based on supabase tables
- Ability to detect changes and print diff (Soon)
- Ability to install module into existing project (ex: auth, realtime, etc) (Soon)

## Getting Started

### Pre-requisites
- Dart (version 3.5.2 or higher)
- Supabase acccount and project setup

### Installation

### Linux & MacOS
```bash
curl -fsSL https://raw.githubusercontent.com/supagen/supagen/refs/heads/main/scripts/install.sh | bash
```

### Windows
Download the `.exe` file from the latest release [here](https://github.com/supagen/supagen/releases/latest)

### Usage
```
Usage: supagen <command> [arguments]

Global options:
-h, --help    Print this usage information.
--verbose     Print verbose output.

Available commands:
  init      Initialize a new Supabase project
  update    Update Supabase table definitions
  version   Print the current version of supagen

Run "supagen help <command>" for more information about a command.
```

## Contributors
<a href="https://github.com/supagen/supagen/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=supagen/supagen" />
</a>

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
