# Modular-Character-Controller-for-Godot-Examples
This repo holds all example projects for [Modular Character Controller](https://github.com/PantheraDigital/Modular-Character-Controller-for-Godot)

Each folder in this repo is a project including all the files needed to open it in Godot. Each project also holds the version of Modular Character Controller it was made with, so they may be out dated.

You can either, download the entire repo for all the projects or just the folder for the project you are interested in.

If you want to download just one project folder and not the entire repo you can do this one of 3 ways: 

**download-directory.github.io** \
Copy, paste, hit enter. \
Use the link to the specific folder you want. \
https://download-directory.github.io/

**Git Sparse Checkout** \
Using the command line.
```
git clone --filter=blob:none --no-checkout https://github.com/dotnet/roslyn.git
cd roslyn
git sparse-checkout init --cone
git sparse-checkout set src/NuGet/Microsoft.NETCore.Compilers
git checkout v4.1.0
```

**GitHub API** \
[Using GitHub API](https://docs.github.com/en/rest/repos/contents?apiVersion=2026-03-10#get-repository-content)
```
GET https://api.github.com/repos/dotnet/roslyn/contents/src/NuGet/Microsoft.NETCore.Compilers?ref=v4.1.0
```

Above solutions found at: https://github.com/orgs/community/discussions/178419#discussioncomment-14827486
