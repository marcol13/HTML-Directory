#!/bin/bash
list=()
fixed_categories=("images","music","documents")

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
        ext="$2 $3 "
        shift 3
        for i in $@
        do
            ext+="\"$i\","
            shift
        done
        echo $ext
    else
        echo "-1"
    fi
}

#1-category_name
function delete_category(){
    if [[ "${fixed_categories[@]}" =~ "$1" ]]
    then
        echo -2
    else
        id_name=( `awk '{print $1}' extension.txt` )
        local line_id=-1
        for i in $(seq 0 $((${#id_name}-1)))
        do
            if [[ "${id_name[$i]}" == "$1" ]]
            then
                line_id=$(($i+1))
                break
            fi
        done
        echo $line_id
    fi
}

function display_help(){
    echo "Pomoc dla skryptu $0:\n\nZałożenia:\n
    \tSkrypt wyświetla podane pliki w formie strony internetowej. Dostępny jest \nw niej podgląd nazwy pliku, daty modyfikacji, ścieżki do pliku, a także odnośnik.\nJeżeli używamy skryptu bez flagi lub z flagami sortującymi to jako argumenty podajemy katalogi lub pliki które mają być uwzględnione przy tworzeniu strony.\nDostępne flagi:\n
    \t-h - pomoc - wyświetla pomoc dla polecenia\n
    \t-a - dodaje nową kategorię; przyjmuje argumenty: nazwa_sekcji opis rozszerze-\n\tnia; nie można dodać kategorii, której nazwa sekcji już istnieje\n
    \t\tPrzykład użycia: \"./script.sh -a text Tekstowe txt doc docx\"\n
    \t-d - usuwa kategorię po nazwie sekcji; nie można usunąć sekcji:\n\t${fixed_categories[*]}\n
    \t\tPrzykład użycia: \"./script.sh -a\"\n
    \t--asc - sortuje wpisy rosnąco po ścieżce do pliku\n
    \t--desc - sortuje wpisy malejąco po ścieżce do pliku\nWszystkie nazwy:\n
    \t ${name[*]}\nWszystkie informacje o rozszerzeniach i nazwach umieszczone są w pliku extension.txt"
}


x="$(echo $1 | head -c 1)"
if [[ "$x" == "-" ]] && [[ "$1" != "--desc" ]]  && [[ "$1" != "--asc" ]]
then
    case "$1" in
        "-h") name=( `awk '{print $1}' extension.txt` )
                echo -e $(display_help $@);;
        "-a") result=$(add_category $@)
                if [[ "$result" == "-1" ]]
                then
                    echo -e "Nieprawidłowe dane\nZobacz pomoc używając flagi -h"
                else
                    echo -ne "\n${result::-1}" >> extension.txt
                fi;;
        "-d") result=$(delete_category $2)
                if [[ "$result" == "-2" ]]
                then
                    echo -e "Nie można usunąć tej kategorii\nZobacz pomoc używając flagi -h"
                elif [[ "$result" == "-1" ]]
                then
                    echo -e "Nie ma takiej kategorii\nZobacz pomoc używając flagi -h"
                else
                    sed -i "${result}d" extension.txt
                    perl -pi -e 'chomp if eof' extension.txt
                fi;;
        *) echo "Nie ma takiej flagi";;
    esac
else
    flag=0
    is_flag=false
    if [[ "$1" == "--desc" ]]
    then
        flag=1
        is_flag=true
    elif [[ "$1" == "--asc" ]]
    then
        flag=2
        is_flag=true
    fi
    for i in $@
    do
        if [[ "$is_flag" == true ]]
        then
            is_flag=false
            continue
        else
            if [ -a "./$i" ]
            then
                list+=(`find "./$i" -type f | grep '^\.\/.*\.\S*$' | sed -E "s/(\.\/)+//"`)
            else
                echo "$i - nie ma takiego pliku/katalogu"
            fi
        fi
    done
    list=( `for i in ${list[@]}; do echo $i; done | sort -u` )
    if [[ "$flag" == "1" ]]
    then
        list=( `for i in ${list[@]}; do echo $i ; done | sort -r` )
    elif [[ "$flag" == "2" ]]
    then
        list=( `for i in ${list[@]}; do echo $i ; done | sort` )
    fi
    
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
        temp_arr=(`echo ${ext[$i]} | sed -E "s/,/ /g" | sed -E "s/\"//g"`)
        temp_files=()
        for j in ${list[@]}
        do
            for k in ${temp_arr[@]}
            do 
                temp_files+=(`echo $j | grep -E "^.*\.$k$"`)
            done
        done
        if [[ "${#temp_files[@]}" == "0" ]]
        then
            code+="<p class=\"empty_info\">Sekcja ${description[$i]} jest pusta</p>"
        else
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
        fi
        code+="</section>"
    done
    echo $code >> index.html
    echo "</div>
</body>
</html>" >> index.html
firefox `pwd`/"index.html"
fi

