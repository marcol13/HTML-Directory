#!/bin/bash
list=()
#section=("images","music","documents")
#ext=('d1=("jpg" "gif" "png" "jpeg" "tiff" "apng" "bmp" "ico" "cur" "jfif" "pjpeg" "pjp" "svg" "tif" "webp")' 'd2=("mp3" "ogg" "wav")' 'd3=("pdf" "doc" "odt")')
#for i in "${ext[@]}";do eval $i;done

#1-path;2-name;3-date;4-hour;5-path_from_disk
function create_element(){
    text="<div class=\"file file-container\">
                    <div class=\"thumb-container\"><img src=\"img/documents.png\" alt=\"$1\"/></div>
                    <p class=\"file-name\">$2</p>
                    <p class=\"modify-date\">$3 $4</p>
                    <p class=\"file-path\">$1</p>
                    <a href=\"$5\"><img src=\"img/sid-view.png\" class=\"eye\"/></a>
                </div>"
    retval=$text
    echo $retval
}

#1-path;2-name;3-date;4-hour;5-path_from_disk
function create_img_element(){
    text="<div class=\"photo photo-container\">
                    <div class=\"thumb-container\"><img src=\"$1\" alt=\"$1\"/></div>
                    <p class=\"file-name\">$2</p>
                    <p class=\"modify-date\">$3 $4</p>
                    <p class=\"file-path\">$1</p>
                    <a href=\"$5\"><img src=\"img/sid-view.png\" class=\"eye\"/></a>
                </div>"
    retval=$text
    echo $retval
}

x="$(echo $1 | head -c 1)"
if [[ "$x" == "-" ]]
then
    case "$1" in
        "-h") echo "tu będzie pomoc";;
        "-a") echo "tu będzie można dodać kategorię";;
        "-d") echo "tu będzie można usunąć kategorię";;
        "--ae") echo "tu będzie można dodać rozszerzenie";;
        "--de") echo "tu będzie można usunąć rozszerzenie";;
        *) echo "Nie ma takiej flagi";;
    esac
else
    for i in $@
    do
        #echo "./$i" 
        if [ -a "./$i" ]
        then
            list+=(`find "./$i" -type f | grep '^\.\/.*\.\S*$' | sed -E "s/(\.\/)+//"`)
        else
            echo "$i - nie ma takiego pliku/katalogu"
        fi
    done
    list=( `for i in ${list[@]}; do echo $i; done | sort -u` )

    
    name=( `awk '{print $1}' extension.txt` )
    description=( `awk '{print $2}' extension.txt` )
    ext=( `awk '{print $3}' extension.txt` )
    code=""
    #sed -E "s/,/ /g"
    n=${#name[@]}
    touch "index.html"
    :>index.html
    echo "<!DOCTYPE html>
<html lang=\"pl\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <link rel=\"stylesheet\" href=\"style.css\">
    <link href=\"https://fonts.googleapis.com/css2?family=Balsamiq+Sans&display=swap\" rel=\"stylesheet\"> 
    <title>Moje pliki</title>
</head>
<body>
    <div class=\"header\">
        <h1 class=\"header-title\"><span class=\"blue\">Moje</span> <span class=\"yellow\">pliki</span></h1>
        <div class=\"menu\">
            <p class=\"menu-item\"><a href=\"#images\">Zdjęcia</a></p>
            <p class=\"menu-item\"><a href=\"#music\">Muzyka</a></p>
            <p class=\"menu-item\"><a href=\"#docs\">Dokumenty</a></p>
        </div>
    </div>
    <div class=\"content\">" >> index.html
    for i in $(seq 0 $(($n-1)))
    do
        code+="<section id=\"${name[$i]}\">
                <h2 class=\"section-title\">${description[$i]}</h2>"
        if [[ "${name[$i]}" == "images" ]]
        then
            code+="<div class=\"info-section photo-container\">
                    <p class=\"info photo-size\">Obraz</p>
                    <p class=\"info\">Nazwa pliku</p>
                    <p class=\"info\">Data modyfikacji</p>
                    <p class=\"info\">Ścieżka do pliku</p>
                    <p class=\"info link-img\">Odnośnik</p>
                </div>"
        else
            code+="<div class=\"info-section file-container\">
                    <p class=\"info\">Plik</p>
                    <p class=\"info\">Nazwa pliku</p>
                    <p class=\"info\">Data modyfikacji</p>
                    <p class=\"info\">Ścieżka do pliku</p>
                    <p class=\"info link-img\">Odnośnik</p>
                </div>"
        fi
        temp_arr=(`echo ${ext[$i]} | sed -E "s/,/ /g" | sed -E "s/\"//g"`)
        #for j in ${list[@]}; do echo $j;done;
        temp_files=()
        for j in ${list[@]}
        do
            for k in ${temp_arr[@]}
            do 
                temp_files+=(`echo $j | grep -E "^.*\.$k$"`)
            done
        done
        #temp_files=(`for j in ${list[@]}; do echo $j | grep -E "^.*\.$temp_arr$";done`)
        for j in ${temp_files[@]}
        do
            time=`ls --full-time $j | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}"`
            path=`pwd`/$j
            file_name=`echo $j | cut -d '.' -f1 | rev | cut -d '/' -f1 | rev`
            if [[ "${name[$i]}" == "images" ]]
            then
                code+=$(create_img_element $j $file_name ${time[@]} $path)
            else
                code+=$(create_element $j $file_name ${time[@]} $path)
            fi
        done
        code+="</section>"
        #echo $i, ${temp_files[@]}
    done
    echo $code >> index.html
    echo "</div>
</body>
</html>" >> index.html
fi

#echo $code
