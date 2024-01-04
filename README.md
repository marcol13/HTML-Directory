<div align="center">

# HTML Directory

  <p align="center">
    Script that will present your local files in nice html layout!
    <br/>
    <i>Project for Operatin Systems classes</i>
    <br/>
    <b>Date of completion: 📆 24.06.2020 📆</b>
  </p>

</div>

## About The Project

HTML Directory is a simple Shell script which creates HTML file based on your local files.
Thank to this, you can browse and preview your files in much nicer design.

## Features

- Create website based on files in given path
- Creating new categories and folders
- Removing categories
- Files preview on website
- Sort files by filename

## Demo

### Website

![image](https://github.com/marcol13/HTML-Directory/assets/56632321/dcd38eb1-a3c9-42f3-b133-14aba011b8c7)

### Functionality

[Screencast from 04.01.2024 21:07:19.webm](https://github.com/marcol13/HTML-Directory/assets/56632321/3589546f-e6b1-4d01-9f3a-cb4c4d8edc02)


## Technologies Used
<p>
  <img alt="Shell Script" src="https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white" />
  <img alt="Linux" src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" />
  <img alt="SASS" src="https://img.shields.io/badge/Sass-CC6699?style=for-the-badge&logo=sass&logoColor=white" />
</p>


## Getting Started

1. You need to have Linux OS.
2. Clone the repository: `git clone https://github.com/marcol13/HTML-Directory`
3. Run `script.sh` on your Linux computer: `./script.sh <options>`
4. Choose option and flags accorgin to your needs. Check out [help](#help) section or just write `./script.sh -h`!

## Help

If you want to run script with default config (showing files only from `images`, `music` and `documents` directories) you need to execute: 

```
./script.sh <path>
```

If you want to add other directories, check below section.

### Flags

- `-h` - show help message for the script
- `-a` - creates new category taking as argument: `<directory> <name> <extensions>`. Example: `./script.sh -a text Tekstowe txt doc docx`. You can also edit extension.txt file to configure your own categories.
- `-d` - deletes category taking as argument: `<directory>`. Example: `./script.sh -d text`
- `--asc` - sort files in ascending order by file name. Example: `./script.sh /home/Desktop --asc`
- `--desc` - sort files in descending order by file name. Example: `./script.sh /home/Desktop --desc`
