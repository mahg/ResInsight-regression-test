ResInsight Regression Tests

Large binary files are stored using Git Large File Storage https://git-lfs.github.com/ These files will initially have a text reference to the large file, and can be replaced with the large binary file using a special git command.

To checkout these large binary files, do the following:

- Make sure git lfs is installed
- `git lfs install`
- `git lfs checkout`
