#!/bin/bash
list=()

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

function create_menu(){
    text="<div class=\"menu\">"
    for i in $(seq 0 $(($n-1)))
    do
        text+="<p class=\"menu-item\"><a href=\"#${name[i]}\">${description[i]}</a></p>"
    done
    text+="        </div>
    </div>
    <div class=\"content\">"
    retval=$text
    echo $retval
}

function add_category(){
    id_name=( `awk '{print $1}' extension.txt` )
    if [[ ! -z $2 ]] && [[ ! -z $3 ]] && [[ ! "${id_name[*]}" == *"$2"* ]] 
    then
        ext="$2 $3"
        shift 3
        for i in $@
        do
            ext+=" \"$i\","
            shift
        done
        echo $ext
    else
        echo "-1"
    fi
}

x="$(echo $1 | head -c 1)"
if [[ "$x" == "-" ]]
then
    case "$1" in
        "-h") echo "tu będzie pomoc";;
        "-a") result=$(add_category $@)
                if [[ "$result" == "-1" ]]
                then
                    echo "Nieprawidłowe dane"
                else
                    echo -ne "\n${result::-1}" >> extension.txt
                fi;;
        "-d") echo "tu będzie można usunąć kategorię";;
        "--ae") echo "tu będzie można dodać rozszerzenie";;
        "--de") echo "tu będzie można usunąć rozszerzenie";;
        *) echo "Nie ma takiej flagi";;
    esac
else
    for i in $@
    do
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
        " >> index.html
    echo $(create_menu) >> index.html
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
        temp_files=()
        for j in ${list[@]}
        do
            for k in ${temp_arr[@]}
            do 
                temp_files+=(`echo $j | grep -E "^.*\.$k$"`)
            done
        done
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
    done
    echo $code >> index.html
    echo "</div>
</body>
</html>" >> index.html
fi

