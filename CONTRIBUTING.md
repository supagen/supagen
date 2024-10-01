# Contributing to Supagen
Thank you for considering contributing to Supagen! Here are some guidelines to help you get started.

## Getting Started

1. **Fork the repository**: Click the "Fork" button at the top right of the repository page.
2. **Clone your fork**: 
    ```sh
    git clone git@github.com:supagen/supagen.git
    cd supagen
    ```
3. **Create a branch**: 
    ```sh
    git checkout -b your-branch-name
    ```

## Making Changes

1. **Install dependencies**: 
    ```sh
    dart pub get
    ```
2. **Make your changes**: Implement your feature or fix the bug.
3. **Run tests**: Ensure all tests pass.
    ```sh
    dart test
    ```

## Running the Project

To run the project, use the following command:
```sh
dart run bin/main.dart <supagen_command>
```

## Submitting Changes

1. **Commit your changes**: 
    ```sh
    git add .
    git commit -m "Description of your changes"
    ```
2. **Push to your fork**: 
    ```sh
    git push origin your-branch-name
    ```
3. **Create a Pull Request**: Go to the original repository and click "New Pull Request".

## Code Style

- Follow the Dart style guide.
- Write clear and concise commit messages.

## Branch Naming

- Use `feat/<issue-id>` for new features. ex: `feat/1`
- Use `bug/<issue-id>` for bug fixes. ex: `bug/1`
- Use `docs/<issue-id>` for documentation changes. ex: `docs/1`

## Commit Messages

- Use conventional commits. For example:
    - `feat(<issue-id>): add new feature`
    - `fix(<issue-id>): resolve bug`
    - `docs(<issue-id>): update README.md`
- Use the present tense ("add feature" not "added feature").
- Use the imperative mood ("move cursor to..." not "moves cursor to...").

## Reporting Issues

If you find a bug or have a feature request, please open an issue on GitHub.

Thank you for your contributions!
